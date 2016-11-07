Pod::Spec.new do |s|
    s.name                      = "KeyedMapper"
    s.version                   = "1.9.0"
    s.summary                   = "Swift JSON Mapper that uses enums for JSON keys"
    s.homepage                  = "https://github.com/Noobish1/KeyedMapper"
    s.license                   = "MIT"
    s.author                    = { "Blair McArthur" => "blair.mcarthur@icloud.com" }
    s.platform                  = :ios, '8.0'
    s.source                    = { :git => "https://github.com/Noobish1/KeyedMapper.git", :tag => s.version.to_s }
    s.requires_arc              = true
    s.source_files              = "KeyedMapper/**/*.swift"
    s.module_name               = "KeyedMapper"
end
