#
# Be sure to run `pod lib lint MKBlePlugMax.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKBlePlugMax'
  s.version          = '0.0.1'
  s.summary          = 'A short description of MKBlePlugMax.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/MokoPlug/MokoPlug_IOS_Pro'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aadyx2007@163.com' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/MokoPlug/MokoPlug_IOS_Pro.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  
  s.resource_bundles = {
    'MKBlePlugMax' => ['MKBlePlugMax/Assets/*.png']
  }
  
  s.subspec 'ConnectModule' do |ss|
    ss.source_files = 'MKBlePlugMax/Classes/ConnectModule/**'
    
    ss.dependency 'MKBlePlugMax/SDK'
    
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  s.subspec 'SDK' do |ss|
    ss.source_files = 'MKBlePlugMax/Classes/SDK/**'
    
    ss.dependency 'MKBaseBleModule'
  end
  
  s.subspec 'CTMediator' do |ss|
    ss.source_files = 'MKBlePlugMax/Classes/CTMediator/**'
    
    ss.dependency 'CTMediator'
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  s.subspec 'Target' do |ss|
    ss.source_files = 'MKBlePlugMax/Classes/Target/**'
    
    ss.dependency 'MKBlePlugMax/Functions'
  end
  
  s.subspec 'Expand' do |ss|
    
    ss.subspec 'BaseController' do |sss|
      sss.source_files = 'MKBlePlugMax/Classes/Expand/BaseController/**'
      
      sss.dependency 'MKBlePlugMax/SDK'
    end
    
    ss.subspec 'View' do |sss|
      sss.subspec 'CountdownPickerView' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Expand/View/CountdownPickerView/**'
      end
      sss.subspec 'ProtectionTextFieldCell' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Expand/View/ProtectionTextFieldCell/**'
      end
      sss.subspec 'SingleSelectedCell' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Expand/View/SingleSelectedCell/**'
      end
      sss.subspec 'TextButtonCell' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Expand/View/TextButtonCell/**'
      end
    end
    
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
  end
  
  s.subspec 'Functions' do |ss|
    
    ss.subspec 'AboutPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/AboutPage/Controller/**'
        
        ssss.dependency 'MKBlePlugMax/Functions/AboutPage/Model'
        ssss.dependency 'MKBlePlugMax/Functions/AboutPage/View'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/AboutPage/Model/**'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/AboutPage/View/**'
        
        ssss.dependency 'MKBlePlugMax/Functions/AboutPage/Model'
      end
    end
    
    ss.subspec 'AdvertisementPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/AdvertisementPage/Controller/**'
      
        ssss.dependency 'MKBlePlugMax/Functions/AdvertisementPage/Model'
        ssss.dependency 'MKBlePlugMax/Functions/AdvertisementPage/View'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/AdvertisementPage/Model/**'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/AdvertisementPage/View/**'
      end
    end
    
    ss.subspec 'BleConnectedIndicatorPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/BleConnectedIndicatorPage/Controller/**'
      end
    end
    
    ss.subspec 'ButtonSettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/ButtonSettingPage/Controller/**'
      
        ssss.dependency 'MKBlePlugMax/Functions/ButtonSettingPage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/ButtonSettingPage/Model/**'
      end
    end
    
    ss.subspec 'DeviceInfoPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/DeviceInfoPage/Controller/**'
      
        ssss.dependency 'MKBlePlugMax/Functions/DeviceInfoPage/Model'

        ssss.dependency 'MKBlePlugMax/Functions/UpdatePage/Controller'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/DeviceInfoPage/Model/**'
      end
    end
    
    ss.subspec 'EnergyPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/EnergyPage/Controller/**'
      
        ssss.dependency 'MKBlePlugMax/Functions/EnergyPage/Model'
        ssss.dependency 'MKBlePlugMax/Functions/EnergyPage/View'
      
        ssss.dependency 'MKBlePlugMax/Functions/SettingPage/Controller'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/EnergyPage/Model/**'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/EnergyPage/View/**'
      end
    end
    
    ss.subspec 'EnergyReportPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/EnergyReportPage/Controller/**'
      
        ssss.dependency 'MKBlePlugMax/Functions/EnergyReportPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/EnergyReportPage/Model/**'
      end
    end
    
    ss.subspec 'IndicatorColorPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/IndicatorColorPage/Controller/**'
      
        ssss.dependency 'MKBlePlugMax/Functions/IndicatorColorPage/Model'
        ssss.dependency 'MKBlePlugMax/Functions/IndicatorColorPage/View'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/IndicatorColorPage/Model/**'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/IndicatorColorPage/View/**'
      end
    end
    
    ss.subspec 'IndicatorPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/IndicatorPage/Controller/**'
      
        ssss.dependency 'MKBlePlugMax/Functions/IndicatorPage/Model'
        ssss.dependency 'MKBlePlugMax/Functions/IndicatorPage/View'
        
        ssss.dependency 'MKBlePlugMax/Functions/BleConnectedIndicatorPage/Controller'
        ssss.dependency 'MKBlePlugMax/Functions/IndicatorColorPage/Controller'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/IndicatorPage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/IndicatorPage/View/**'
      end
    end
    
    ss.subspec 'LoadStatusPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/LoadStatusPage/Controller/**'
      
        ssss.dependency 'MKBlePlugMax/Functions/LoadStatusPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/LoadStatusPage/Model/**'
      end
    end
    
    ss.subspec 'PeriodicalReportingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/PeriodicalReportingPage/Controller/**'
      
        ssss.dependency 'MKBlePlugMax/Functions/PeriodicalReportingPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/PeriodicalReportingPage/Model/**'
      end
    end
    
    ss.subspec 'PowerOnMode' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/PowerOnMode/Controller/**'
      end
    end
    
    ss.subspec 'PowerPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/PowerPage/Controller/**'
      
        ssss.dependency 'MKBlePlugMax/Functions/PowerPage/Model'
        
        ssss.dependency 'MKBlePlugMax/Functions/SettingPage/Controller'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/PowerPage/Model/**'
      end
    end
    
    ss.subspec 'ProtectionConfigPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/ProtectionConfigPage/Controller/**'
      
        ssss.dependency 'MKBlePlugMax/Functions/ProtectionConfigPage/Model'
        ssss.dependency 'MKBlePlugMax/Functions/ProtectionConfigPage/Header'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/ProtectionConfigPage/Model/**'
        ssss.dependency 'MKBlePlugMax/Functions/ProtectionConfigPage/Header'
      end
      
      sss.subspec 'Header' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/ProtectionConfigPage/Header/**'
      end
    end
    
    ss.subspec 'ProtectionSwitchPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/ProtectionSwitchPage/Controller/**'
      
        ssss.dependency 'MKBlePlugMax/Functions/ProtectionConfigPage/Controller'
      end
    end
    
    ss.subspec 'ScanPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/ScanPage/Controller/**'
      
        ssss.dependency 'MKBlePlugMax/Functions/ScanPage/Model'
        ssss.dependency 'MKBlePlugMax/Functions/ScanPage/View'
        
        ssss.dependency 'MKBlePlugMax/Functions/TabBarPage/Controller'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/ScanPage/View/**'
        
        ssss.dependency 'MKBlePlugMax/Functions/ScanPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/ScanPage/Model/**'
      end
    end
    
    ss.subspec 'SettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/SettingPage/Controller/**'
      
        ssss.dependency 'MKBlePlugMax/Functions/SettingPage/Model'
        
        ssss.dependency 'MKBlePlugMax/Functions/AdvertisementPage/Controller'
        ssss.dependency 'MKBlePlugMax/Functions/PowerOnMode/Controller'
        ssss.dependency 'MKBlePlugMax/Functions/PeriodicalReportingPage/Controller'
        ssss.dependency 'MKBlePlugMax/Functions/EnergyReportPage/Controller'
        ssss.dependency 'MKBlePlugMax/Functions/ProtectionSwitchPage/Controller'
        ssss.dependency 'MKBlePlugMax/Functions/LoadStatusPage/Controller'
        ssss.dependency 'MKBlePlugMax/Functions/ButtonSettingPage/Controller'
        ssss.dependency 'MKBlePlugMax/Functions/IndicatorPage/Controller'
        ssss.dependency 'MKBlePlugMax/Functions/DeviceInfoPage/Controller'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/SettingPage/Model/**'
      end
    end
        
    ss.subspec 'SwitchPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/SwitchPage/Controller/**'
      
        ssss.dependency 'MKBlePlugMax/Functions/SwitchPage/Model'
        
        ssss.dependency 'MKBlePlugMax/Functions/SettingPage/Controller'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/SwitchPage/Model/**'
      end
    end
    
    ss.subspec 'TabBarPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/TabBarPage/Controller/**'
        
        ssss.dependency 'MKBlePlugMax/Functions/SwitchPage/Controller'
        ssss.dependency 'MKBlePlugMax/Functions/PowerPage/Controller'
        ssss.dependency 'MKBlePlugMax/Functions/EnergyPage/Controller'
      end
    end
    
    ss.subspec 'UpdatePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/UpdatePage/Controller/**'
      
        ssss.dependency 'MKBlePlugMax/Functions/UpdatePage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBlePlugMax/Classes/Functions/UpdatePage/Model/**'
      end
    
      sss.dependency 'iOSDFULibrary'
    end
    
    ss.dependency 'MKBlePlugMax/SDK'
    ss.dependency 'MKBlePlugMax/ConnectModule'
    ss.dependency 'MKBlePlugMax/Expand'
  
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
    ss.dependency 'HHTransition'
    ss.dependency 'MLInputDodger'
    
  end
  
end
