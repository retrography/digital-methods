# Data Wrangling with OpenRefine

__TODO:__

- Import hierarchical data

------

Data quality is essential to quality data analysis. Redundancy within or between records, unrecorded or empty values, as well as inconsistency in various forms are data quality issues that one should be prepared to deal with, specially when using available data.

OpenRefine (formerly Google Refine) provides a simple and effective interactive interface to run many of the basic data cleaning and quality verification tasks. In this exercise, you will learn some of the main techniques involved in automated data cleaning using [*OpenRefine*](http://openrefine.org/), including:

1. Removing duplicate records
2. Splitting fields with multiple values
3. Analyzing the distribution and the range of values
4. Clustering and harmonizing values in a field
5. Creating new fields based on the existing fields
6. Comparing and manipulating the field contents

 The main objective is to prepare the inventory data from the [Powerhouse museum](http://www.powerhousemuseum.com/) for further analysis. Powerhouse museum dataset consists of detailed metadata on all the collection objects, including title, description, several categories the item belongs to, provenance information, and a persistent link to the object on the museum website. 

### 1. Obtaining and importing the data[](https://programminghistorian.org/lessons/cleaning-data-with-openrefine#getting-started-installing-openrefine-and-importing-data)

Download the inventory data of the Powerhouse museum from [here](https://canvas.vu.nl/courses/31025/files/466427/download?verifier=Uo0qX1LA51jiqtmuAUU4jiXV6NmFjytAn55SmOws&wrap=1). The file is in TSV or tab-separated format. Create a new project in OpenRefine and import the downloaded file.

Make sure to unselect the ‘Quotation marks are used to enclose cells containing column separators’ checkbox, since the file does not use quoting. You can also select the ‘Parse cell text into numbers, dates, ...’ , so that OpenRefine automatically detect numbers.

### 2. Getting to know your data

OpenRefine supports faceted search views, which are a great first step to explore your data by making visible the value distributions and facilitating the search for aberrant values. You could consider a [facet (Links to an external site.)Links to an external site.](http://en.wikipedia.org/wiki/Faceted_search) as a lens through which you view a specific subset of the data, based on a criterion of your choice.

In order to create a facet, click the triangle (![triangle.png](https://canvas.vu.nl/courses/31025/files/466631/preview?verifier=MhIC891w7zGN5ek1QOrTblSuZeoWXtUZ9NGC9gs2)) in front of one of the column names and select Facet from the drop down menu. There are different types of facet to choose from.

- The text facets are best used on fields with redundant values (Categories for instance). If you run into a ‘too many to display’ error, you can choose to raise the choice count limit above the 2,000 default, but too high a limit can slow down the application (5,000 is usually a safe choice).
- The numeric facets are best to check the distribution of the numeric values in a quick way. Note that the Numeric facets only work on fields that contain some recognized numeric values. So, if you haven't enabled number parsing in the import options, you may have to first transform the field values into numerical format (**Edit cells > Common transforms > To number**) before attempting a numeric facet.

For more options, you can select Customized facets: facet by blank, for instance, comes handy to find out how many values were filled in for each field. 

### 3. Removing blanks

Any record without a Record ID is considered void and unworthy of keeping. Use a numeric facet to filter out all the non-blank values of the Record ID column (showing only the blanks), then delete the matching rows. You can remove rows by clicking the little triangle beside the first column, called All. Then from the crop down menu select (**Edit rows >** **Remove all matching rows**). 

Note that the blank Record IDs are not really blank, but rather contain a single space character.

### 4. Removing duplicate records

Another step in data cleaning is to detect and remove duplicate records. These can be spotted by sorting them on a unique value, such as the Record ID. Here we assume that Record ID is actually a unique value for each entry. This assumption must be thoroughly tested when working with important datasets.

Sort Record ID values as numbers (choose **Sort...** from the context menu). A Sort menu appears at the top of the grid. Choose **Reorder rows permanently** in order to make the reordering permanent. In OpenRefine, sorting is only a visual aid, unless you explicitly choose to make the reordering permanent. 

Identical rows (with similar Record IDs) are now adjacent to each other. In order to remove duplicates in OpenRefine, follow the procedure below:

1. From the Record ID context menu, choose **Edit cells >** **Blank down**. This removes the Record ID for every duplicate record.
2. Create a **Facet by blank** on Record ID, and remove the blanks just like the exercise above.

### 5. Transforming values

We would like to make sure the categories attributed to each entity (Categories field) are clean and free from redundancy. Once the duplicate records have been removed, we can have a closer look at the Categories field. These categories are contained within the same field, separated by a pipe character ‘|’. Record 9, for instance, contains three: ‘Mineral samples|Specimens|Mineral Samples-Geological’.

Lets first check for possible anomalies in this field, such as blank categories (a pipe character at the beginning, two pipe characters with nothing between them, or a pipe character in the end). From the context menu on the Categories, choose **Text Filter**. Try the following filters:

- || (with regular expression unchecked)
- ^\| (with regular expression checked)
- \|$ (with regular expression checked)

You will see that the first two queries yield results. While the first query is self-explaining, the second one may not be as obvious. This is because it contains pattern-matching symbols constituting a [regular expression](https://www.regular-expressions.info/). While regular expressions are not a part of this tutorial, this example gives you a preview of how powerful they are as a data manipulation tool, specially when it comes to textual data. You can practice with regular expressions using any [online regex tester](https://regex101.com/).

Now lets remove these anomalies from the Categories field. Choose **Edit cells > Transform...** to transform the field values. OpenRefine uses a simplified language called [GREL](https://github.com/OpenRefine/OpenRefine/wiki/General-Refine-Expression-Language) to achieve this. Use the following expression to remove the double-pipes from the field:

```
value.replace('||', '|')
```

Now redo the same step with the following expression, in order to remove pipes at the beginning of field values:

```
value.replace(/^\|/, '')
```

### 6. Atomizing and clustering values

In order to analyze in detail the use of the keywords, the values of the *Categories* field need to be split up into individual cells on the basis of the pipe character. Choose **Edit cells > Split multi-valued cells** on the *Categories* field entering | as the value separator. This will multiply the number of rows (but not the records). Up to this point the rows and the records represented the same entities. Try switching between the row view and the record view from the top of the grid to understand the difference between the two concepts. 

In the rows view, each row represents a couple of Record IDs and a single Category, enabling manipulation of each one individually. The records view has an entry for each Record ID, which can have different categories on different rows (grouped together in grey or white), but each record is manipulated as a whole.

Once the content of a field has been properly atomized, filters, facets, and clusters can be applied to give a quick overview of values. Try a text facet to see how many different categories there are and their frequencies (you can sort by name or by count). 

But what if the category values have been entered with minimal differences, creating redundant categories? For instance, you will notice that the list of categories contains both 'Agricultrual Equipment' and 'Agricultural equipment'.

In order to check for that, OpenRefine proposes to cluster facet choices together based on various similarity methods. Push the Cluster button on top of the categories list to see the Cluster & Edit window (or **Edit cells > Cluster and edit...** from the context menu). Do the clustering once using the Fingerprint function and once using the Ngram-Fingerprint function. Merge the values whenever it allows to resolve a case inconsistency. 

To further harmonize the data-entry format for the categories you can equalize the cases as well. To do this, select **Edit cells > Common transforms > To titlecase** from the context menu.

Now that the values have been clustered individually, we can put them back together in a single cell. From the context menu on Categories select **Edit cells > Join multi-valued cells**. Choose the pipe character as a separator. The rows now look like before, with a multi-valued Categories field.

Finally, it is a possibility that in some cases the same value has been entered twice (e.g. record 41). In such a case we would like to remove the duplicates. This can be done using the transform method seen in the practice above. You can use the following expression to achieve this:

```
value.split('|').uniques().join('|')
```

### 7. Splitting fields into two or more fields

If you look at the Height field, you will notice that in many cases the field contains both the height of the item and the unit of measurement. This is probably not a good idea, because it prevents the use of height as a numeric value. You can split a field into two fields (or more), using **Edit column > Split** into several columns... from the context menu. Use a single space as separator and split into a maximum of two columns. Then cluster and merge the similar values in Height 2.

Do the same with Width and Depth.

### 8. Removing unneeded fields

Keep Record ID, Categories, Registration Number and the new Height (1 and 2), Width(1 and 2) and Depth (1 and 2) fields, and remove all the rest by clicking **Edit column > Remove** this column from the context menu.

### 9. Exporting your cleaned data

If you want to save the data that you have been cleaning, you need to export them by clicking on the ‘**Export**’ menu top-right of the screen. Most of the time you will have to export the file into CSV (comma-separated) format if you woule like to open it in an analysis or statistics software (like R) afterwards. 

*Question: Is the final dataset tidy?*

------------

This tutorial is published under [CC-BY](https://creativecommons.org/licenses/by/4.0/deed.en) license and is based on [Data Cleaning with OpenRefine](https://programminghistorian.org/lessons/cleaning-data-with-openrefine).