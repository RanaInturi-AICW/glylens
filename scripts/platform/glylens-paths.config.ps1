# GlyLens development path configuration (BP1.3)
# Edit GLYLENS_DEV_ROOT to change the default install drive/folder.
# Override for this session: $env:GLYLENS_DEV_ROOT = 'E:\glylens-dev'

$devRoot = if ($env:GLYLENS_DEV_ROOT) { $env:GLYLENS_DEV_ROOT.TrimEnd('\') } else { 'D:\glylens-dev' }

# Android SDK: override with GLYLENS_ANDROID_SDK (e.g. D:\AndroidStudio-Sdk)
$androidSdk = if ($env:GLYLENS_ANDROID_SDK) {
    $env:GLYLENS_ANDROID_SDK.TrimEnd('\')
}
elseif (Test-Path 'D:\AndroidStudio-Sdk\platform-tools') {
    'D:\AndroidStudio-Sdk'
}
else {
    Join-Path $devRoot 'android\sdk'
}

$script:GlyLensPathsConfig = @{
    DevRoot       = $devRoot
    DevDrive      = (Split-Path $devRoot -Qualifier)
    FlutterRoot   = Join-Path $devRoot 'flutter'
    FlutterBin    = Join-Path $devRoot 'flutter\bin'
    AndroidSdk    = $androidSdk
    AndroidStudio = Join-Path $devRoot 'android-studio'
    JdkSearch     = @(
        (Join-Path $devRoot 'jdk')
        (Join-Path $devRoot 'jdk\*')
        'D:\Program Files\Eclipse Adoptium'
        'C:\Program Files\Eclipse Adoptium'
    )
    PubCache      = Join-Path $devRoot 'pub-cache'
    MinFreeGbDev  = 50
    MinFreeGbOS   = 15
}
