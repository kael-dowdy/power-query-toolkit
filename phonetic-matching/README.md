# Phonetic matching

Phonetic keys help group text that may sound alike despite differences in spelling. Use them to find possible matches for review, rather than to prove that two records represent the same person or entity.

## Available functions

| Function | How this implementation works | When to consider it |
| --- | --- | --- |
| [Soundex](soundex.pq) | Keeps the first cleaned character and appends three mapped consonant digits, truncating or padding with zeros. | A compact first-pass grouping key for surname matching, especially English-language names. Verify compatibility before comparing with codes from another system. |
| [Metaphone-style key](metaphone-style-key.pq) | Applies ordered letter-pattern replacements such as PH to F and CK to K, then filters and collapses characters. Produces a variable-length text key. | Exploring spelling patterns that a compact Soundex-style key may group differently. Evaluate it against known matching and nonmatching pairs before relying on it. |

Neither function depends on the other or on an external helper query. Both accept one text argument. Their keys are different formats: compare Soundex keys with Soundex keys, and custom Metaphone-style keys with keys from that same function.

## Choosing between them

Start with Soundex-style grouping when you want a short, simple candidate key for names. Soundex was designed for surname indexing by sound.

Consider the custom Metaphone-style function when you want to experiment with explicit letter-pattern substitutions. A longer key does not automatically mean a better match. This implementation has not been shown to outperform Soundex or to match a standard Metaphone implementation.

For either approach, test with names representative of your data. Measure both missed matches and unrelated names sharing a key. Combine phonetic matches with other fields or manual review before merging records. These rules are English-oriented and do not establish pronunciation equivalence across languages.

## Setup and use

1. Paste each file's contents into a separate blank query using the Advanced Editor.
2. Name the queries `soundex` and `metaphone-style-key`.
3. Invoke the required function with a text value.

Example calls (illustrative; not runtime-tested here):

```powerquery
soundex("Smith")
#"metaphone-style-key"("Smith")
```

To add candidate keys to a table, invoke the chosen function for each name in a custom column. Review nulls, blanks, errors, and non-text values before calling either function; their parameter declarations require text.

## Implementation notes and limitations

These files preserve the original logic. Syntax was checked with Microsoft's Power Query parser; runtime behavior and algorithm conformance have not been validated.

### Soundex variant

- Cleansing retains ASCII letters and digits, then converts letters to uppercase. Despite the original comment, digits are not removed.
- Adjacent duplicate suppression checks identical original characters, rather than all adjacent characters that map to the same digit.
- Handling of the first character and H/W separators may differ from standard Soundex rules.
- Text that becomes empty after cleansing returns null.

Do not assume its output matches SQL Server SOUNDEX or another library without testing.

### Custom Metaphone-style variant

- Removes characters outside A-Z after uppercasing.
- Applies replacements throughout the text, rather than restricting every rule to a particular position.
- The source's vowel-removal comment is broader than its implementation: the B-Z selection also retains E, I, O, and U.
- Some transformation choices are marked as uncertain in the original source.
- Empty and one-character inputs need explicit runtime testing because the code uses indexed ranges and substrings.

This is not a verified implementation of standard Metaphone or Double Metaphone. It does not produce primary and alternate Double Metaphone keys.

## Background references

- [National Archives: Soundex indexing system](https://www.archives.gov/research/census/soundex)
- [PostgreSQL: phonetic matching algorithms](https://www.postgresql.org/docs/current/fuzzystrmatch.html)

These references explain the algorithms generally; they do not certify these M implementations.

## License

See the repository's root `LICENSE` file for MIT license terms.
