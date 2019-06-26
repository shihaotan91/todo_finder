# TODO Finder

## Problem Statement

It's common to see `TODOs` in code. It's also common for `TODOs` to remain as to-dos for a long time. One way we can solve this problem is to have a service that runs through all files in a given directory and checks for any instances of the key-phrase `"TODO"`, flagging each one of them out for humans to continue working on them.

## The Application

This application takes in a directory and looks through all files in that directory for `TODOs` statements.

## Application Considerations

### Commented Code VS Uncommented Code

`TODOs` are usually written in files as commented code. In that sense, as much as possible we should be only flagging out files whose `TODOs` are commented. However, since different programming languages have different syntax for commenting out codes, if this application were to take all programming languages into consideration, an extremely complex regular expression will need to be used as a matcher to find out which part of the code are commented.

To avoid that, I decided to only match the two most common syntax in commenting out code in modern programming languages. And that is

`#` for Ruby, Python, Perl, etc...
`//` for Javascript, Golang, Java, etc...

Ruby and Javascript will be used as test examples in this application.

### Valid TODOs examples for Ruby/Javascript

Only TODOs that are commented for Javascript and Ruby files will be included in output

Example of a JS file that WILL NOT be shown in output

```
var todo = "TODO"

function sayToDo() {
  console.log(todo)
}
```

Example of a JS file that WILL be shown in output
```
// TODO

/*
Todo this thing
*/
```

Example of a Ruby file that WILL NOT be shown in output

```
todo = "TODO"

def todo
 puts todo
end
```

Example of a Ruby file that WILL be shown in output
```
# TODO
```

### Valid TODOs in all other file types

TODOs of any other file types will be included in the output regardless of whether they are commented or not

Example of a HTML file that will be shown in output
```
<h1>TODO</h1>

```

## What's needed to run it

This application in written in plain Ruby without any supporting libaries. So you only need to install Ruby language to run it.

Step 1: [Download Brew](https://brew.sh/) (You can skip this if you already have brew)
Step 2: Run `brew install ruby` in your terminal if you are on MAC. If not visit [HERE](https://www.ruby-lang.org/en/documentation/installation/) to see how to download Ruby for other systems.

## How to run it

To get a list of files with `TODOs` in them that are in `test_dir`

Simply run `ruby directory_reader.rb`

To run through all the unit tests, I've created a bin executable file for it.

Simply run `bin/run_specs`