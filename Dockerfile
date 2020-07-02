FROM oblique/archlinux-yay:latest
# Update to latest versions
RUN pacman -Syu --noconfirm
# Install requirements
RUN pacman -S --noconfirm git cmake mesa
RUN sudo -u aur yay --noconfirm --mflags --skipinteg -S android-ndk
RUN sudo -u aur yay --noconfirm -S corrade-git
ARG MAGNUM_VERSION=v2020.06
RUN git clone https://github.com/mosra/corrade.git && \
    cd corrade && git checkout ${MAGNUM_VERSION} && cd .. && \
    git clone https://github.com/mosra/magnum.git && \
    cd magnum && git checkout ${MAGNUM_VERSION} && cd .. && \
    git clone https://github.com/mosra/magnum-plugins.git && \
    cd magnum-plugins && git checkout ${MAGNUM_VERSION}
# Build corrade, magnum and magnum-plugins for Android
ARG ANDROID_SDK_VERSION=24
RUN for buildType in Release Debug; do \
        for abi in arm64 arm x86 x86_64; do \
            for os in linux windows; do \
                abiSuf=""; \
                if [ $abi == arm64 ]; then \
                    abiSuf=-v8a; \
                elif [ $abi == arm ]; then \
                    abiSuf=eabi-v7a; \
                else \
                    abiSuf=""; \
                fi; \
                libSuf=""; \
                if [ $abi == x86_64 ]; then \
                    libSuf=64; \
                fi; \
                cd /corrade && \
                mkdir -p build-android-$abi-$buildType && cd build-android-$abi-$buildType && \
                cmake .. \
                    -DCMAKE_SYSTEM_NAME=Android \
                    -DCMAKE_SYSTEM_VERSION=$ANDROID_SDK_VERSION \
                    -DCMAKE_ANDROID_ARCH_ABI=$abi$abiSuf \
                    -DCMAKE_ANDROID_STL_TYPE=c++_static \
                    -DCMAKE_BUILD_TYPE=$buildType \
                    -DCMAKE_INSTALL_PREFIX=/opt/android-ndk/platforms/android-$ANDROID_SDK_VERSION/arch-$abi/usr \
                    -DCMAKE_FIND_ROOT_PATH="/opt/android-ndk/platforms/android-$ANDROID_SDK_VERSION/arch-$abi;/opt/android-ndk/toolchains/llvm/prebuilt/$os-x86_64/sysroot" \
                    -DCORRADE_INCLUDE_INSTALL_PREFIX=/opt/android-ndk/toolchains/llvm/prebuilt/$os-x86_64/sysroot/usr \
                    -DCMAKE_ANDROID_NDK=/opt/android-ndk \
                    -DLIB_SUFFIX=$libSuf && \
                cmake --build . && \
                cmake --build . --target install ; \
            done \
        done \
    done
RUN for buildType in Release Debug; do \
        for abi in arm64 arm x86 x86_64; do \
            for os in linux windows; do \
                abiSuf=""; \
                if [ $abi == arm64 ]; then \
                    abiSuf=-v8a; \
                elif [ $abi == arm ]; then \
                    abiSuf=eabi-v7a; \
                else \
                    abiSuf=""; \
                fi; \
                libSuf=""; \
                if [ $abi == x86_64 ]; then \
                    libSuf=64; \
                fi; \
                cd /magnum && \
                mkdir -p build-android-$abi-$buildType && cd build-android-$abi-$buildType && \
                cmake .. \
                    -DCMAKE_SYSTEM_NAME=Android \
                    -DCMAKE_SYSTEM_VERSION=$ANDROID_SDK_VERSION \
                    -DCMAKE_ANDROID_ARCH_ABI=$abi$abiSuf \
                    -DCMAKE_ANDROID_STL_TYPE=c++_static \
                    -DCMAKE_BUILD_TYPE=$buildType \
                    -DCMAKE_INSTALL_PREFIX=/opt/android-ndk/platforms/android-$ANDROID_SDK_VERSION/arch-$abi/usr \
                    -DCMAKE_FIND_ROOT_PATH="/opt/android-ndk/platforms/android-$ANDROID_SDK_VERSION/arch-$abi;/opt/android-ndk/toolchains/llvm/prebuilt/$os-x86_64/sysroot" \
                    -DMAGNUM_INCLUDE_INSTALL_PREFIX=/opt/android-ndk/toolchains/llvm/prebuilt/$os-x86_64/sysroot/usr \
                    -DCMAKE_ANDROID_NDK=/opt/android-ndk \
                    -DLIB_SUFFIX=$libSuf \
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
        for abi in arm64 arm x86 x86_64; do \
            for os in linux windows; do \
                abiSuf=""; \
                if [ $abi == arm64 ]; then \
                    abiSuf=-v8a; \
                elif [ $abi == arm ]; then \
                    abiSuf=eabi-v7a; \
                else \
                    abiSuf=""; \
                fi; \
                libSuf=""; \
                if [ $abi == x86_64 ]; then \
                    libSuf=64; \
                fi; \
                cd /magnum-plugins && \
                mkdir -p build-android-$abi-$buildType && cd build-android-$abi-$buildType && \
                cmake .. \
                    -DCMAKE_SYSTEM_NAME=Android \
                    -DCMAKE_SYSTEM_VERSION=$ANDROID_SDK_VERSION \
                    -DCMAKE_ANDROID_ARCH_ABI=$abi$abiSuf \
                    -DCMAKE_ANDROID_STL_TYPE=c++_static \
                    -DCMAKE_BUILD_TYPE=$buildType \
                    -DCMAKE_INSTALL_PREFIX=/opt/android-ndk/platforms/android-$ANDROID_SDK_VERSION/arch-$abi/usr \
                    -DCMAKE_FIND_ROOT_PATH="/opt/android-ndk/platforms/android-$ANDROID_SDK_VERSION/arch-$abi;/opt/android-ndk/toolchains/llvm/prebuilt/$os-x86_64/sysroot" \
                    -DMAGNUM_INCLUDE_INSTALL_PREFIX=/opt/android-ndk/toolchains/llvm/prebuilt/$os-x86_64/sysroot/usr \
                    -DCMAKE_ANDROID_NDK=/opt/android-ndk \
                    -DLIB_SUFFIX=$libSuf \
                    -DWITH_OPENGEXIMPORTER=ON \
                    -DWITH_TINYGLTFIMPORTER=ON && \
                cmake --build . && \
                cmake --build . --target install ; \
            done \
        done \
    done