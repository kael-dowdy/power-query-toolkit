# Power Query Toolkit

Reusable Power Query M functions, queries, and examples for data preparation in Power BI and Excel.

Created and maintained by **Kael Dowdy**, Senior Business Intelligence and Data Analytics Consultant and owner of **Maverick DataWorks LLC**.

This collection shares practical approaches to common data preparation tasks, with documentation to help you understand, adapt, and use each example. Examples are published incrementally as they are reviewed and documented.

## Browse by purpose

| Category | What it covers |
| --- | --- |
| `data-cleansing` | Cleaning text, checking numeric values, removing text fragments, and related reference data. |
| `text-formatting` | Formatting text, including adding bullets to nonblank lines. |
| `dates-and-calendars` | Date and time tables, calendar variants, and custom workweek boundaries. |
| `phonetic-matching` | Soundex and custom Metaphone-style keys for comparing similar-sounding text. |
| `images` | Preparing image data and splitting Base64 text into chunks for downstream use. |
| `data-sources` | Source connections, query examples, and preparing source-specific schemas. |

This table describes the planned organization. Categories appear as their first examples are published. Read each category's README for its available examples and setup requirements.

## Getting started

1. Choose an example and read its comments and category README.
2. Check its required parameters, helper queries, reference data, and source connections.
3. Create required dependencies first, using the documented Power Query names.
4. For a complete query or function, create a blank query and paste its M code into the **Advanced Editor**.
5. Name the query as instructed. A GitHub filename and a Power Query query name are separate things.
6. Invoke functions with the required arguments, or configure the source for a table query.
7. Review the results using representative data before using the example in your own solution.

Files use the `.pq` extension for Power Query M source code. You can browse and copy individual examples; cloning the repository is optional.

Some files may contain an expression or several separate definitions rather than one complete query. Follow their instructions: separate definitions generally need separate Power Query queries.

## Documentation and dependencies

Documentation is intended to explain:

- The problem an example solves and when to use it.
- Inputs, parameters, outputs, and usage examples.
- Required helper queries, reference data, and setup steps.
- Assumptions, limitations, and validation status.

Preserve documented query names when other queries reference them. Source-specific examples may require changes to connections, credentials, column names, and data types.

## Compatibility and testing

Examples target Power Query M. Availability and behavior can vary between Power BI, Excel, and other Power Query hosts, particularly for connectors and authentication.

Check each example's compatibility notes and validation status. Locale, date conventions, source schemas, and data volume can affect results. Test with your own data before production use.

## Questions and contributions

Use this repository's Issues feature, where enabled, for questions, bug reports, and suggestions. Include the filename, your Power Query environment, a small anonymized input example, expected results, and actual results.

Contributions are welcome. Explain what your proposed change does and how you checked it. Do not include credentials or confidential data.

## Author and contact

**Kael Dowdy**  
Senior Business Intelligence and Data Analytics Consultant  
Owner, Maverick DataWorks LLC

Connect with me on [LinkedIn](https://www.linkedin.com/in/kaeldowdy/) for professional networking and consulting inquiries.

## License

Licensed under the MIT License. See the `LICENSE` file for the full terms, including the warranty disclaimer and limitation of liability.

Retain the required copyright and license notices when redistributing copies or substantial portions of the code. Preserve any applicable third-party notices.
