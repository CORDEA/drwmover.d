# drwmover.d

Command to move android image resources.

Move following resources...

- `Icon@1.png`
- `Icon@1.5.png`
- `Icon@2.png`
- `Icon@3.png`
- `Icon@4.png`

to correct drawable dir.

- `drawable-mdpi/ic_d.png`
- `drawable-hdpi/ic_d.png`
- `drawable-xhdpi/ic_d.png`
- `drawable-xxhdpi/ic_d.png`
- `drawable-xxxhdpi/ic_d.png`

## Usage

```bash
$ dmd drwmover.d handler.d
$ # Move resources
$ ./drwmover --source ~/$PATH/ --target ~/AndroidStudioProjects/$APP/app/src/main/res/ --name ic_d
$ # Rename and move resources
$ ./drwmover --source ~/$PATH/Icon --target "~/AndroidStudioProjects/$APP/app/*/ic_d"
$ # Or
$ ./drwmover --source ~/$PATH/Icon --target "~/AndroidStudioProjects/$APP/app/src/main/res/*/ic_d"
```
