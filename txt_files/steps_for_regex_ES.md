
Objective: transform the elderscrolls text into a wall of text

Step 1: find the following identifiers &, <, > and replace them accordingly.

Step 2: delete the whitespace by using find/replace
find: \n\n replace: \n

Step 3: sort the http links using find/replace
find: ^(.+)\n(http.+)$ replace: <a href="\2">\1</a>

Step 4: Save as a txt file and open a new HTML document
then copy and paste everything from the text into the body.

Step 5: Place an <ol> tag and enclose the <a> tags

Step 6: replace the <a> tags and transform them into <l> tags by using find/replace
find: <a href.+</a>    replace:<li>\0</li>

Step 7: congradualtions you completed the example.