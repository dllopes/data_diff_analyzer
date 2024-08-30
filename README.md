# DataDiffAnalyzer

## Project Summary

DataDiffAnalyzer is a lightweight Ruby on Rails application designed to efficiently analyze data files and identify the smallest difference between specified values.

## Prerequisites

- **Ruby version**: 3.2.2
- **Rails version**: 7.0.8

Ensure you have the specified versions of Ruby and Rails installed to avoid

## Installation

To set up and run the DataDiffAnalyzer, follow these simple steps:

1. **Clone the repository**

   ```bash
   git clone https://github.com/dllopes/data_diff_analyzer.git
   cd data_diff_analyzer

2. **Install dependencies**

   ```bash
   bundle install
   
3. **Running the Application**

   To run the analysis, use the following command:
    ```bash
    rake data_diff:analyze FILE_NAME=your_file_name
   ```
    Replace your_file_name with the appropriate file name, such as soccer or w_data. The application will automatically handle file extensions, so you can provide the name with or without the .dat extension.
