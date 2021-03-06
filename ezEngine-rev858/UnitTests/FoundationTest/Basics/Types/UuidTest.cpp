#include <PCH.h>
#include <Foundation/Types/Uuid.h>
#include <Foundation/IO/MemoryStream.h>


EZ_CREATE_SIMPLE_TEST(Basics, Uuid)
{
  EZ_TEST_BLOCK(ezTestBlock::Enabled, "Uuid Generation")
  {
    ezUuid ShouldBeInvalid;

    EZ_TEST_BOOL(ShouldBeInvalid.IsValid() == false);

    ezUuid FirstGenerated;
    FirstGenerated.CreateNewUuid();
    EZ_TEST_BOOL(FirstGenerated.IsValid());

    ezUuid SecondGenerated;
    SecondGenerated.CreateNewUuid();
    EZ_TEST_BOOL(SecondGenerated.IsValid());

    EZ_TEST_BOOL(!(FirstGenerated == SecondGenerated));
    EZ_TEST_BOOL(FirstGenerated != SecondGenerated);
  }

  EZ_TEST_BLOCK(ezTestBlock::Enabled, "Uuid Serialization")
  {
    ezUuid Uuid;
    EZ_TEST_BOOL(Uuid.IsValid() == false);

    Uuid.CreateNewUuid();
    EZ_TEST_BOOL(Uuid.IsValid());


    ezMemoryStreamStorage StreamStorage;


    // Create reader
    ezMemoryStreamReader StreamReader(&StreamStorage);

    // Create writer
    ezMemoryStreamWriter StreamWriter(&StreamStorage);

    StreamWriter << Uuid;

    ezUuid ReadBack;
    EZ_TEST_BOOL(ReadBack.IsValid() == false);

    StreamReader >> ReadBack;

    EZ_TEST_BOOL(ReadBack == Uuid);
  }
}

