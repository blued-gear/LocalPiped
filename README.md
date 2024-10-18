# LocalPiped

Package [Piped](https://github.com/TeamPiped/Piped/) (Fronend + Backend) to run locally.
This will significantly rise your chances to not get blocked by Google without self-hosting.

## Build and use
### Dependencies

- Linux
- git
- wget
- JDK 21
- Node.js, pnpm

### AppImage

To build an AppImage to run Piped on your PC:

```bash
cd Appimage
./build.sh
```

This will result in the file `LocalPiped-x86_64.AppImage`.
Run it an then open [http://localhost:8171](http://localhost:8171) in your browser.\
Alternatively you can use an exiting and enter [http://localhost:8170](http://localhost:8170) as the API URL.

Per default, it will create a temporary db at `/tmp/localpiped.db`.
If you want to store the data persistent, set a jdbc-url for the db it the env-variable `hibernate_connection_url`. 
Example: `hibernate_connection_url="jdbc:sqlite:/home/user/Documents/localpiped.db"`

#### Build Env-Vars

- `NO_BUILD_DEP`: if set, build will skip the build of all subcomponents
- `NO_BUILD_FESERVER`: if set, the *frontendserver* subcomponent will not be build
   (but the existing executable will be used)
- `FRONTEND_KEEP_GIT`: if set, the sources for the *frontend* will be kept as is;
   otherwise the latest commit will be pulled and the patches applied
- `BACKEND_KEEP_GIT`: if set, the sources for the *backend* will be kept as is;
   otherwise the latest commit will be pulled and the patches applied
- `PROXY_KEEP_IMG`: if set, the docker-image for the *pipedproxy* will not be deleted after the executable is extracted
