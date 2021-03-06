# Docker image with [corrade](https://github.com/mosra/corrade), [magnum](https://github.com/mosra/magnum) and [magnum-plugins](https://github.com/mosra/magnum-plugins) for Android

Pull the container and copy the Android NDK files necessary to build Android projects with magnum.
```
docker pull boonto/magnum-android:v2020.06-24
docker create --name magnum-android boonto/magnum-android
docker cp magnum-android:/opt/android-ndk .
```

Can be built with different magnum & Android SDK versions, replace `<magnum-version>` and `<android-sdk-version>` with the desired versions.
```
docker build -t magnum-android:<magnum-version>-<android-sdk-version> --build-arg MAGNUM_VERSION=<magnum-version> --build-arg ANDROID_SDK_VERSION=<android-sdk-version> .
```
