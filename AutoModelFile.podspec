#
#  Be sure to run `pod spec lint AutoModelFile.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.


Pod::Spec.new do |s|

  s.name         = "AutoModelFile"
  s.version      = "1.0.2"
  s.summary      = "可以自动解析字典并且生成 model .h 和.m文件"

  
  s.description  = <<-DESC
可以自动解析字典并且生成 model .h 和.m文件,支持嵌套结构字典，并且可以通过block设置属性的注释，只支持模拟器运行
                   DESC

  s.homepage     = "https://github.com/ShelockWindy/AutoModelFile"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "ShelockWindy" => "2517185883@qq.com" }
 
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.



   s.platform     = :ios, "7.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.

  #s.source       = { :git => "https://github.com/ShelockWindy/AutoModelFile.git", :commit => "80dbf410b62163e4ce1ec5fbf51bc4471666d910" }
 s.source       = { :git => "https://github.com/ShelockWindy/AutoModelFile.git", :tag => s.version }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

 # s.source_files  = "Classes", "Classes/**/*.{h,m}"
 # s.exclude_files = "Classes/Exclude"

# AutoModelFile  在工程中以子目录显示
s.source_files     = 'AutoModelFile/AutoModelFile/AutoModelFileManager/*.{h,m}'

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

   s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
