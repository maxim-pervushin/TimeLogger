platform :ios, '8.0'

use_frameworks!
inhibit_all_warnings!

xcodeproj 'HyperTimeLogger/HyperTimeLogger.xcodeproj'

app_targets = [:'HyperTimeLogger', :'HyperTimeLogger Alpha', :'HyperTimeLogger Beta']

app_targets.each do |app_target|
  target app_target do
    pod 'CocoaLumberjack', '2.0.0'
    pod 'UIColor+BFPaperColors', :head
    pod 'HexColors'
    pod 'FMDB'
    pod 'XYPieChart'
    pod 'ZLBalancedFlowLayout'
  end
end


ext_targets = [:'TodayExtension', :'TodayExtension Alpha', :'TodayExtension Beta']

ext_targets.each do |ext_target|
  target ext_target do
    pod 'CocoaLumberjack', '2.0.0'
    pod 'UIColor+BFPaperColors', :head
    pod 'HexColors'
    pod 'FMDB'
    pod 'ZLBalancedFlowLayout'
  end
end
