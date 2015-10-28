
EZ_FORCE_INLINE const char* ezWorld::GetName() const
{ 
  return m_Data.m_sName.GetString().GetData(); 
}

EZ_FORCE_INLINE ezGameObjectHandle ezWorld::CreateObject(const ezGameObjectDesc& desc)
{
  ezGameObject* pNewObject;
  return CreateObject(desc, pNewObject);
}

EZ_FORCE_INLINE bool ezWorld::IsValidObject(const ezGameObjectHandle& object) const
{
  CheckForMultithreadedAccess();
  EZ_ASSERT_DEV(object.IsInvalidated() || object.m_InternalId.m_WorldIndex == m_uiIndex,
    "Object does not belong to this world. Expected world id %d got id %d", m_uiIndex, object.m_InternalId.m_WorldIndex);

  return m_Data.m_Objects.Contains(object);
}

EZ_FORCE_INLINE bool ezWorld::TryGetObject(const ezGameObjectHandle& object, ezGameObject*& out_pObject) const
{
  CheckForMultithreadedAccess();
  EZ_ASSERT_DEV(object.IsInvalidated() || object.m_InternalId.m_WorldIndex == m_uiIndex,
    "Object does not belong to this world. Expected world id %d got id %d", m_uiIndex, object.m_InternalId.m_WorldIndex);

  ObjectStorageEntry storageEntry = { nullptr };
  bool bResult = m_Data.m_Objects.TryGetValue(object, storageEntry);
  out_pObject = storageEntry.m_Ptr;
  return bResult;
}

EZ_FORCE_INLINE ezUInt32 ezWorld::GetObjectCount() const
{
  return m_Data.m_ObjectStorage.GetCount();
}

EZ_FORCE_INLINE ezInternal::WorldData::ObjectStorage::Iterator ezWorld::GetObjects()
{
  return m_Data.m_ObjectStorage.GetIterator(0);
}

EZ_FORCE_INLINE ezInternal::WorldData::ObjectStorage::ConstIterator ezWorld::GetObjects() const
{
  return m_Data.m_ObjectStorage.GetIterator(0);
}

EZ_FORCE_INLINE void ezWorld::Traverse(VisitorFunc visitorFunc, TraversalMethod method /*= DepthFirst*/)
{
  if (method == DepthFirst)
  {
    m_Data.TraverseDepthFirst(visitorFunc);
  }
  else // method == BreadthFirst
  {
    m_Data.TraverseBreadthFirst(visitorFunc);
  }
}

template <typename ManagerType>
ManagerType* ezWorld::CreateComponentManager()
{
  CheckForMultithreadedAccess();
  EZ_CHECK_AT_COMPILETIME_MSG(EZ_IS_DERIVED_FROM_STATIC(ezComponentManagerBase, ManagerType), 
    "Not a valid component manager type");

  const ezUInt16 uiTypeId = ManagerType::TypeId();
  if (uiTypeId >= m_Data.m_ComponentManagers.GetCount())
  {
    m_Data.m_ComponentManagers.SetCount(uiTypeId + 1);
  }

  ManagerType* pManager = static_cast<ManagerType*>(m_Data.m_ComponentManagers[uiTypeId]);
  if (pManager == nullptr)
  {
    pManager = EZ_NEW(&m_Data.m_Allocator, ManagerType)(this);
    pManager->Initialize();
    
    m_Data.m_ComponentManagers[uiTypeId] = pManager;
  }

  return pManager;
}

template <typename ManagerType>
void ezWorld::DeleteComponentManager()
{
  CheckForMultithreadedAccess();

  const ezUInt16 uiTypeId = ManagerType::TypeId();
  if (uiTypeId < m_Data.m_ComponentManagers.GetCount())
  {
    if (ManagerType* pManager = static_cast<ManagerType*>(m_Data.m_ComponentManagers[uiTypeId]))
    {
      m_Data.m_ComponentManagers[uiTypeId] = nullptr;

      pManager->Deinitialize();
      DeregisterUpdateFunctions(pManager);
      EZ_DELETE(&m_Data.m_Allocator, pManager);
    }
  }
}

template <typename ManagerType>
EZ_FORCE_INLINE ManagerType* ezWorld::GetComponentManager() const
{
  CheckForMultithreadedAccess();
  EZ_CHECK_AT_COMPILETIME_MSG(EZ_IS_DERIVED_FROM_STATIC(ezComponentManagerBase, ManagerType), 
    "Not a valid component manager type");

  const ezUInt16 uiTypeId = ManagerType::TypeId();
  ManagerType* pManager = nullptr;
  if (uiTypeId < m_Data.m_ComponentManagers.GetCount())
  {
    pManager = static_cast<ManagerType*>(m_Data.m_ComponentManagers[uiTypeId]);
  }

  EZ_ASSERT_DEV(pManager != nullptr, "Component Manager '%s' (id: %u) does not exists. Call 'CreateComponentManager' first.", 
    ezGetStaticRTTI<typename ManagerType::ComponentType>()->GetTypeName(), uiTypeId);
  return pManager;
}

inline bool ezWorld::IsValidComponent(const ezComponentHandle& component) const
{
  CheckForMultithreadedAccess();
  const ezUInt16 uiTypeId = component.m_InternalId.m_TypeId;

  if (uiTypeId < m_Data.m_ComponentManagers.GetCount())
  {
    if (ezComponentManagerBase* pManager = m_Data.m_ComponentManagers[uiTypeId])
    {
      return pManager->IsValidComponent(component);
    }
  }

  return false;
}

template <typename ComponentType>
inline bool ezWorld::TryGetComponent(const ezComponentHandle& component, ComponentType*& out_pComponent) const
{
  CheckForMultithreadedAccess();
  EZ_CHECK_AT_COMPILETIME_MSG(EZ_IS_DERIVED_FROM_STATIC(ezComponent, ComponentType),
    "Not a valid component type");

  const ezUInt16 uiTypeId = component.m_InternalId.m_TypeId;

  if (uiTypeId < m_Data.m_ComponentManagers.GetCount())
  {
    if (ezComponentManagerBase* pManager = m_Data.m_ComponentManagers[uiTypeId])
    {
      ezComponent* pComponent = nullptr;
      bool bResult = pManager->TryGetComponent(component, pComponent);
      out_pComponent = static_cast<ComponentType*>(pComponent);
      return bResult;
    }
  }

  return false;
}

EZ_FORCE_INLINE void ezWorld::SendMessage(const ezGameObjectHandle& receiverObject, ezMessage& msg,
  ezObjectMsgRouting::Enum routing /*= ezObjectMsgRouting::Default*/)
{
  CheckForMultithreadedAccess();

  ezGameObject* pReceiverObject = NULL;
  if (TryGetObject(receiverObject, pReceiverObject))
  {
    pReceiverObject->SendMessage(msg, routing);
  }
}

EZ_FORCE_INLINE const ezInternal::SpatialData& ezWorld::GetSpatialData() const
{
  return m_SpatialData;
}

EZ_FORCE_INLINE ezAllocatorBase* ezWorld::GetAllocator()
{
  return &m_Data.m_Allocator;
}

EZ_FORCE_INLINE ezInternal::WorldLargeBlockAllocator* ezWorld::GetBlockAllocator()
{
  return &m_Data.m_BlockAllocator;
}

EZ_FORCE_INLINE void ezWorld::TransferThreadOwnership()
{
  m_Data.m_ThreadID = ezThreadUtils::GetCurrentThreadID();
}

EZ_FORCE_INLINE void ezWorld::SetUserData(void* pUserData)
{
  m_Data.m_pUserData = pUserData;
}

EZ_FORCE_INLINE void* ezWorld::GetUserData() const
{
  return m_Data.m_pUserData;
}

//static
EZ_FORCE_INLINE ezUInt32 ezWorld::GetWorldCount()
{
  return s_Worlds.GetCount();
}

//static
EZ_FORCE_INLINE ezWorld* ezWorld::GetWorld(ezUInt32 uiIndex)
{
  return s_Worlds[uiIndex];
}

EZ_FORCE_INLINE void ezWorld::CheckForMultithreadedAccess() const
{
  EZ_ASSERT_DEV(!m_Data.m_bIsInAsyncPhase, "World must not be accessed while in async update phase.");
  EZ_ASSERT_DEV(m_Data.m_ThreadID == ezThreadUtils::GetCurrentThreadID(), "World must not be accessed from another thread than the creation thread.");
}

EZ_FORCE_INLINE ezGameObject* ezWorld::GetObjectUnchecked(ezUInt32 uiIndex) const
{
  return m_Data.m_Objects.GetValueUnchecked(uiIndex).m_Ptr;
}
