
#源于 简书 update by src 2018/08/30
# Sets the target folders and the final framework product.
# 如果工程名称和Framework的Target名称不一样的话，要自定义FMKNAME
#FMK_NAME="MyFramework"
FMK_NAME=${PROJECT_NAME}

# Install dir will be the final output to the framework.
# The following line create it in the root folder of the current project.
# 这里改成从文件读取
export SF_DEST_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )/../Framework"
export CONFIGURATION="Debug"
if [ -f ${SF_DEST_DIR}/../CONFIG_FW.TXT ]
then
FW_TARGET_DIR=$(<${SF_DEST_DIR}/../CONFIG_FW.TXT)
INSTALL_DIR=${FW_TARGET_DIR}/${FMK_NAME}.framework
fi

# Working dir will be deleted after the framework creation.
# Release
WRK_DIR=build
DEVICE_DIR=${WRK_DIR}/"${CONFIGURATION}"-iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/"${CONFIGURATION}"-iphonesimulator/${FMK_NAME}.framework

# -configuration ${CONFIGURATION}
# Clean and Building both architectures.
# note: src update 这里改成用参数来定是debug 还是release
xcodebuild -configuration "${CONFIGURATION}" -target "${FMK_NAME}" -sdk iphoneos clean build
xcodebuild -configuration "${CONFIGURATION}" -target "${FMK_NAME}" -sdk iphonesimulator clean build

# Cleaning the oldest.
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi
mkdir -p "${INSTALL_DIR}"
cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"

# Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product.
lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"
rm -r "${WRK_DIR}"
open "${INSTALL_DIR}"
