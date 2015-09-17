#pragma once

#include <Foundation/Strings/StringUtils.h>

namespace ezInternal
{
  template <typename T, bool isString>
  struct HashHelperImpl;
}

/// Base class which marks a class as containing string data
class ezThisIsAString
{
};

/// Base class for strings, which implements all read-only string functions.
template <typename Derived>
class ezStringBase : public ezThisIsAString
{
public:
  /// Returns whether the string is an empty string.
  bool IsEmpty() const; // [tested]

  /// Returns true, if this string starts with the given string.
  bool StartsWith(const char* szStartsWith) const; // [tested]

  /// Returns true, if this string starts with the given string. Case insensitive.
  bool StartsWith_NoCase(const char* szStartsWith) const; // [tested]

  /// Returns true, if this string ends with the given string.
  bool EndsWith(const char* szEndsWith) const; // [tested]

  /// Returns true, if this string ends with the given string. Case insensitive.
  bool EndsWith_NoCase(const char* szEndsWith) const; // [tested]

  /// Returns a pointer to the first occurrence of szStringToFind, or nullptr if none was found.
  /// To find the next occurrence, use an ezStringView which points to the next position and call FindSubString again.
  const char* FindSubString(const char* szStringToFind, const char* szStartSearchAt = nullptr) const; // [tested]

  /// Returns a pointer to the first occurrence of szStringToFind, or nullptr if none was found. Case insensitive.
  /// To find the next occurrence, use an ezStringView which points to the next position and call FindSubString again.
  const char* FindSubString_NoCase(const char* szStringToFind, const char* szStartSearchAt = nullptr) const; // [tested]

  /// Returns a pointer to the last occurrence of szStringToFind, or nullptr if none was found.
  /// szStartSearchAt allows to start searching at the end of the string (if it is nullptr) or at an earlier position.
  const char* FindLastSubString(const char* szStringToFind, const char* szStartSearchAt = nullptr) const; // [tested]

  /// Returns a pointer to the last occurrence of szStringToFind, or nullptr if none was found. Case insensitive.
  /// szStartSearchAt allows to start searching at the end of the string (if it is nullptr) or at an earlier position.
  const char* FindLastSubString_NoCase(const char* szStringToFind, const char* szStartSearchAt = nullptr) const; // [tested]

  /// Searches for the word szSearchFor. If IsDelimiterCB returns true for both characters in front and back of the word, the position is returned. Otherwise nullptr.
  const char* FindWholeWord(const char* szSearchFor, ezStringUtils::EZ_CHARACTER_FILTER IsDelimiterCB, const char* szStartSearchAt = nullptr) const; // [tested]

  /// Searches for the word szSearchFor. If IsDelimiterCB returns true for both characters in front and back of the word, the position is returned. Otherwise nullptr. Ignores case.
  const char* FindWholeWord_NoCase(const char* szSearchFor, ezStringUtils::EZ_CHARACTER_FILTER IsDelimiterCB, const char* szStartSearchAt = nullptr) const; // [tested]

  /// Compares this string with the other one. Returns 0 for equality, -1 if this string is 'smaller', 1 otherwise.
  ezInt32 Compare(const char* pString2) const; // [tested]

  /// Compares up to a given number of characters of this string with the other one. Returns 0 for equality, -1 if this string is 'smaller', 1 otherwise.
  ezInt32 CompareN(const char* pString2, ezUInt32 uiCharsToCompare) const; // [tested]

  /// Compares this string with the other one. Returns 0 for equality, -1 if this string is 'smaller', 1 otherwise. Case insensitive.
  ezInt32 Compare_NoCase(const char* pString2) const; // [tested]

  /// Compares up to a given number of characters of this string with the other one. Returns 0 for equality, -1 if this string is 'smaller', 1 otherwise. Case insensitive.
  ezInt32 CompareN_NoCase(const char* pString2, ezUInt32 uiCharsToCompare) const; // [tested]

  /// Compares this string with the other string for equality.
  bool IsEqual(const char* pString2) const; // [tested]

  /// Compares up to a given number of characters of this string with the other string for equality. Case insensitive.
  bool IsEqualN(const char* pString2, ezUInt32 uiCharsToCompare) const; // [tested]

  /// Compares this string with the other string for equality.
  bool IsEqual_NoCase(const char* pString2) const; // [tested]

  /// Compares up to a given number of characters of this string with the other string for equality. Case insensitive.
  bool IsEqualN_NoCase(const char* pString2, ezUInt32 uiCharsToCompare) const; // [tested]

  /// \brief Computes the pointer to the n-th character in the string. This is a linear search from the start.
  const char* ComputeCharacterPosition(ezUInt32 uiCharacterIndex) const;

private:
  const char* InternalGetData() const;
  const char* InternalGetDataEnd() const;
  ezUInt32 InternalGetElementCount() const;

private: // friends

  template <typename DerivedLhs, typename DerivedRhs>
  friend bool operator== (const ezStringBase<DerivedLhs>& lhs, const ezStringBase<DerivedRhs>& rhs);

  template <typename DerivedLhs, typename DerivedRhs>
  friend bool operator!= (const ezStringBase<DerivedLhs>& lhs, const ezStringBase<DerivedRhs>& rhs);

  template <typename DerivedLhs, typename DerivedRhs>
  friend bool operator< (const ezStringBase<DerivedLhs>& lhs, const ezStringBase<DerivedRhs>& rhs);

  template <typename DerivedLhs, typename DerivedRhs>
  friend bool operator> (const ezStringBase<DerivedLhs>& lhs, const ezStringBase<DerivedRhs>& rhs);

  template <typename DerivedLhs, typename DerivedRhs>
  friend bool operator<= (const ezStringBase<DerivedLhs>& lhs, const ezStringBase<DerivedRhs>& rhs);

  template <typename DerivedLhs, typename DerivedRhs>
  friend bool operator>= (const ezStringBase<DerivedLhs>& lhs, const ezStringBase<DerivedRhs>& rhs);

  template <typename T, bool isString>
  friend struct ezInternal::HashHelperImpl;
};


#include <Foundation/Strings/Implementation/StringBase_inl.h>

