FROM greyltc/archlinux-aur:latest

# Update to latest versions
RUN pacman -Syu --noconfirm

# Install requirements
RUN pacman -S --noconfirm cmake
RUN aur-install android-ndk-26
RUN aur-install corrade-git
ARG MAGNUM_VERSION=master
RUN git clone https://github.com/mosra/corrade.git && \
    cd corrade && git checkout ${MAGNUM_VERSION} && cd .. && \
    git clone https://github.com/mosra/magnum.git && \
    cd magnum && git checkout ${MAGNUM_VERSION} && cd .. && \
    git clone https://github.com/mosra/magnum-plugins.git && \
    cd magnum-plugins && git checkout ${MAGNUM_VERSION}

# Build corrade, magnum and magnum-plugins for Android
ARG ANDROID_SDK_VERSION=31
RUN for buildType in Release Debug; do \
        for abi in arm64-v8a x86_64; do \
            for os in linux windows; do \
                cd /corrade && \
                mkdir -p build-android-$abi-$buildType && cd build-android-$abi-$buildType && \
                cmake .. \
                    -DCMAKE_SYSTEM_NAME=Android \
                    -DCMAKE_SYSTEM_VERSION=$ANDROID_SDK_VERSION \
                    -DCMAKE_ANDROID_ARCH_ABI=$abi \
                    -DCMAKE_ANDROID_STL_TYPE=c++_static \
                    -DCMAKE_BUILD_TYPE=$buildType \
                    -DCMAKE_INSTALL_PREFIX=/opt/android-ndk/toolchains/llvm/prebuilt/$os-x86_64/sysroot/usr \
                    -DCMAKE_ANDROID_NDK=/opt/android-ndk && \
                cmake --build . && \
                cmake --build . --target install ; \
            done \
        done \
    done
RUN for buildType in Release Debug; do \
        for abi in arm64-v8a x86_64; do \
            for os in linux windows; do \
                cd /magnum && \
                mkdir -p build-android-$abi-$buildType && cd build-android-$abi-$buildType && \
                cmake .. \
                    -DCMAKE_SYSTEM_NAME=Android \
                    -DCMAKE_SYSTEM_VERSION=$ANDROID_SDK_VERSION \
                    -DCMAKE_ANDROID_ARCH_ABI=$abi \
                    -DCMAKE_ANDROID_STL_TYPE=c++_static \
                    -DCMAKE_BUILD_TYPE=$buildType \
                    -DCMAKE_INSTALL_PREFIX=/opt/android-ndk/toolchains/llvm/prebuilt/$os-x86_64/sysroot/usr \
                    -DCMAKE_ANDROID_NDK=/opt/android-ndk \
                    -DWITH_ANDROIDAPPLICATION=ON \
                    -DWITH_ANYIMAGEIMPORTER=ON \
                    -DWITH_OBJIMPORTER=ON \
                    -DTARGET_GLES2=OFF &&\
                cmake --build . && \
                cmake --build . --target install ; \
            done \
        done \
    done
RUN for buildType in Release Debug; do \
        for abi in arm64-v8a x86_64; do \
            for os in linux windows; do \
                cd /magnum-plugins && \
                mkdir -p build-android-$abi-$buildType && cd build-android-$abi-$buildType && \
                cmake .. \
                    -DCMAKE_SYSTEM_NAME=Android \
                    -DCMAKE_SYSTEM_VERSION=$ANDROID_SDK_VERSION \
                    -DCMAKE_ANDROID_ARCH_ABI=$abi \
                    -DCMAKE_ANDROID_STL_TYPE=c++_static \
                    -DCMAKE_BUILD_TYPE=$buildType \
                    -DCMAKE_INSTALL_PREFIX=/opt/android-ndk/toolchains/llvm/prebuilt/$os-x86_64/sysroot/usr \
                    -DCMAKE_ANDROID_NDK=/opt/android-ndk \
                    -DWITH_OPENGEXIMPORTER=ON \
                    -DWITH_GLTFIMPORTER=ON && \
                cmake --build . && \
                cmake --build . --target install ; \
            done \
        done \
    done
