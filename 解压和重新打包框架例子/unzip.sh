rm -rf arm64
mkdir arm64
cp -r OpenGLESImage.framework ./arm64/OpenGLESImage.framework
cd arm64/OpenGLESImage.framework
lipo OpenGLESImage -thin arm64 -output OpenGLESImage.arm64
ar -x OpenGLESImage.arm64
#lipo -create OpenGLESImage.arm64 -output OpenGLESImage
rm -rf OpenGLESImage.arm64

ls
echo "All done!"
