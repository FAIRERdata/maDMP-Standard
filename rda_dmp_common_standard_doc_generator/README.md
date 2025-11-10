# Instructions to update the user-friendly Application Profile visible on [GitHub pages](https://fairerdata.github.io/maDMP-Standard/) 

The <b>GC-RDA maDMP Excel Workbook</b> contains information such as fieldnames, property ids, descriptions, example values, user-friendly questions, data types, allowed values, cardinalities, requirements, and dependencies. The information is specifically present in the worksheet, GC maDMP Master sheet; which is commonly referred to as the “orange tab”. Follow these instructions when changes have been made to the standard in the <b>GC-RDA maDMP Excel Workbook</b> by the working group and you want to publish them.

## 1. Update the Application Profile Google Sheets

The GC-RDA maDMP Excel Workbook contains all relevant information for the the user-friendly Application Profile visible on [GitHub pages](https://fairerdata.github.io/maDMP-Standard/). First step is to change the formatting and convert to the <b>GC-RDA maDMP Application Profile</b> Google Sheets. 

Code and instructions to update the [GC-RDA maDMP Application Profile](https://docs.google.com/spreadsheets/d/e/2PACX-1vTLLFvV7jnRCAdef34_JgN6py7GPNQGZkizXr6dEUW-X2oEA_AZQXLjrQxHcHZZsIMWQCS3mqOPxlKx/pub?gid=750759343#) are found in [conversion](https://github.com/FAIRERdata/maDMP-Standard/tree/Master/rda_dmp_common_standard_doc_generator/Conversion).

## 2. Generate a new README file

A utility, written in `Go`, for generating the Web documentation of the GCWG-RDA maDMP Standard. This utility uses the sources held in a set of 5 Google Sheets [GC-RDA maDMP Application Profile](https://docs.google.com/spreadsheets/d/e/2PACX-1vTLLFvV7jnRCAdef34_JgN6py7GPNQGZkizXr6dEUW-X2oEA_AZQXLjrQxHcHZZsIMWQCS3mqOPxlKx/pub?gid=750759343#) which are "published" in `CSV` format at the URLs listed in the config file: [config.yaml](config.yaml), and creates the resulting documentation as a file called "README.md" which is, by default, written into the `output` folder.

Anytime you want to 'refresh' the local documentation file from the Google Spreadsheet sources, simply delete the `db.sqlite` file from the `output` folder, and re-run the utility. This will rebuild the database from the Google Spreadsheet data, and then rebuild the documentation file (`README.md`)in the `output` folder.

Written by Paul Walk (paul@paulwalk.net)\
Revised by [Esther Liu](https://github.com/estherliu02), [Emily Chu](https://github.com/emily0c), [Dominique Charles](https://github.com/dominiquecharlesECCC), [Jackie Cao](https://github.com/UWtheshy)  

### Prerequisites

1. A working [Go](https://golang.org) environment (check the `GOPATH` system environment variable was set correctly after you installed GO, see how to check and edit system environment variables on the screenshot below)
2. This Github repository, checked out into a working copy or downloaded locally
3. [GCC compiler 64-bit](https://jmeubank.github.io/tdm-gcc/) installed and found in the 'path' system enviornment variable. If working in a Windows environment, the path is found in System properties > System environment variables. Find the 'path' for VScode, and install GCC using that path without the /bin at the end.
   ![Screenshot of Windows "Edit the system environment variables" feature](https://github.com/FAIRERdata/maDMP-Standard/blob/Master/rda_dmp_common_standard_doc_generator/src/Capture%20Path.PNG "System environement variables")

### Instructions to compile and run this utility

These instructions work as written for VS Code. If using other editors or the Command Prompt, syntax may need to be slightly modified. 

#### 1. Initialize the module and download required packages
```bash
go mod init github.com/FAIRERdata/maDMP-Standard/tree/tests/rda_dmp_common_standard_doc_generator

go get -u github.com/sirupsen/logrus@67a7fdcf741f4d5cee82cb9800994ccfd4393ad0
go get -u gopkg.in/yaml.v3
go get -u github.com/gocarina/gocsv@c6a9c812ac269510ec596e469aff422e694ec6fd
go get -u github.com/jinzhu/gorm
go get -u github.com/goki/ki/ki

go get -u github.com/jinzhu/gorm/dialects/sqlite@v1.9.16
```

#### 2. Compile the sources

In a powershell terminal, go into the `src` sub-directory and run: 
```bash
$env:CGO_ENABLED="1"
go build -o ../rda_dmp_common_standard_doc_generator.exe
```
This will build an executable file called `rda_dmp_common_standard_doc_generator` in the rda_dmp_common_standard_doc_generator directory. 

#### 3. Set up your configuration file

This utility uses a [single configuration file](config.yaml) for all of it's configuration (i.e. it takes no arguments). The configuration file must exist in the same directory as the executable. In most circumstances, you should be able to use the configuration file provided in this repository.

To update the version number in the header, edit the document title in the config.yaml (you can also directly modify the version number in the README file after you create it).

#### 4. Run the utility

Use `cd ..` to go back to `rda_dmp_common_standard_doc_generator` folder and run: 

```bash
./rda_dmp_common_standard_doc_generator
```

This should create two new files, both in the `output` folder:

1. `db.sqlite`
2. `README.md`

#### 5. Publish the new documentation
Simply copy or move the `README.md` file from the `output` folder to the top level folder of this Github repository (replacing the one that is there).

### Styling Github Pages Website
After the `README.md` file is uploaded, the [website](https://fairerdata.github.io/maDMP-Standard/) is automatically deployed. 

The current website theme is the Jekyll theme [Cayman](https://github.com/pages-themes/cayman). 

If changes to the default styling of the website need to be made (e.g. changes to the width of tables, font-size, colours, etc.) to better suit the information presented, edit the `SCSS` styling sheet. 

Use the [style.scss](https://github.com/FAIRERdata/maDMP-Standard/blob/Master/assets/css/style.scss) sheet found in this repository path `maDMP-Standard/assets/css`. 
CSS code should be written underneath the comment 

```/* Following is css code to change the default styling of the Jekyll theme */```

Comparing with the default stylings of the Cayman theme [style sheet](https://github.com/pages-themes/cayman/blob/master/_sass/jekyll-theme-cayman.scss) and `style.scss` can determine the corresponding elements which need to be overrided/changed. Using Inspect Element on the website can also determine the corresponding elements to refer to in the CSS code.

Modifying a specific element on the website may need an `id` associated with the element. Assigning an `id` can be done by either modifying the [documentation.go](https://github.com/FAIRERdata/maDMP-Standard/blob/Master/rda_dmp_common_standard_doc_generator/src/documentation.go) code. Or manually through the outputted [README.md](https://github.com/FAIRERdata/maDMP-Standard/blob/Master/README.md) file. Note that if manually done, each time the README.md file is regenerated, the changes must be done again.

Modifying the structure of the README.md file can be done through modifying the [documentation.go](https://github.com/FAIRERdata/maDMP-Standard/blob/Master/rda_dmp_common_standard_doc_generator/src/documentation.go) or [tree.go](https://github.com/FAIRERdata/maDMP-Standard/blob/Master/rda_dmp_common_standard_doc_generator/src/tree.go).

For changing the text in the header banner of the Github page, edit the 'description' of the repository in the About section (gear icon in the right panel on the repository landing page).
For changing the title of the Github page, change the `document_title` in [config.yaml](https://github.com/FAIRERdata/maDMP-Standard/blob/Master/rda_dmp_common_standard_doc_generator/config.yaml) before you run the Go code.

Changes to the html layout theme can be done in the file [default.html](https://github.com/FAIRERdata/maDMP-Standard/blob/Master/_layouts/default.html).
