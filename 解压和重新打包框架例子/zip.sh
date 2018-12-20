
cd arm64/OpenGLESImage.framework
libtool -o OpenGLESImage.arm64 *.o
lipo -create OpenGLESImage.arm64 -output OpenGLESImage
# rm -rf OpenGLESImage.arm64 *.o
ls
echo "All done!"
