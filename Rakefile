# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  require 'motion-cocoapods'
  require 'bubble-wrap/all'
  require 'motion-blitz'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Mahaffeys'
  app.pods do
  	pod 'PKRevealController', '=2.0.1'
    pod 'SVProgressHUD'
  end

  require 'motion/project/template/ios'
  require 'bubble-wrap/all'
  require 'motion-testflight'
  require 'motion-blitz'
  

  app.testflight.sdk = 'vendor/TestFlight'
	app.testflight.api_token = 'd0188ac2d0ae9d8384abfe645d598872_MjIwMTA'
	app.testflight.team_token = '327c91c1d067ba3e369a2fc1e5421f00_MzQzNDk0MjAxNC0wMi0yMyAxNjo1Mzo1NC41OTE3OTg'
	app.testflight.app_token = 'bbe7c4b2-16d0-474b-baaf-980a35b94b7c'
end
