##xcmount: Easier-ish Xcode group management

`xcmount` helps keep your Xcode groups in sync with your files on disk.

You specify the way in which you want paths on disk to be mounted in your project using a simple textfile: your `xcmountfile`. `xcmount` will find or create the group you want to work with in Xcode and then build the directory structure below it.

## Installation

- Clone the repo
- Build and put the product somewhere in your path

##xcmountfile

The `xcmountfile` is a simple Ruby DSL that abstracts the creation off a slightly clumsy JSON structure used by the tool.

```
xcodeproj "xcmount.xcodeproj"

target "xcmount", "Specs" do
  mount "xcmount/Source"
end

target "Specs" do
  mount "Specs/Source", "Specs/Source"
end

```

###`xcodeproj(project_name)`

Takes the path of the project file to work with.

###`target(*targets)`

Can take a comma separated list of strings (or single string) of targets that you want to configure. You can have multiple `target` blocks to apply different mountings. `target` takes a block which contains calls to `mount` 

###`mount(dir_path, [mount_path])`

`mount` with one argument will use the path for both the location on disk and the place in the project to mount that tree.

`mount` with two arguments will mount the dir_path to the mount_path

---

##Why?

Working in a team (or on your own with many feature branches) you will eventually hit merge conflicts in the Xcode project where files have been added, removed or moved. If you are sensible enough you can just delete your whole source tree from Xcode and then drag it back in from Finder and everything will be bright and happy again.

This is a chore and if you want to achieve a nice git history then this process makes rebasing feature branches a nightmare. `xcmount` is here to automate this process.

##How

`xcmount` performs the following steps

- It parses your `xcmountfile` for instructions (see `PASConfiguration`)
- It finds the mounting point in the Xcode project, it may create the group and any intermediary groups (see `PASObjectFinder`)
- It recursively removes all children from this group (see `PASDismounter`)
    - It will also remove these children from all build phases
- It builds the tree to match the directory structure (see `PASTreeBuilder`)
- It adds the new group into the required targets (see `PASMounter`)
- It sorts the project tree (see `PASTreeSorter`)
- It writes the changes out

#Warning

If you are not using some kind of source control then you almost certainly should not be using this tool. You should probably also go and research source control and get it in your bag of every day tools.

##Plan

- Write a script that will attempt to handle merge conflicts that are purely from file changes
    - Will need to examine their/our project to see if it's safe to just run `xcmount` and continue 
- Only rebuild what needs to be rebuilt - this would allow the tool to be run cleanly without modifying the project when nothing has changed
  
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request