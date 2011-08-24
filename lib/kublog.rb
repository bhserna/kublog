require "rails"
require 'coffee-script'
require "jquery-rails"
require "twitter"
require "fb_graph"
require "friendly_id"
require "carrierwave"
require "rmagick"
require "sanitize"
require "liquid"

require "kublog/engine"
require "kublog/version"

module Kublog
  
  autoload   :Notifiable, 'kublog/notifiable'
  
  module Notification
    autoload :Email,      'kublog/notification/email'
    autoload :EmailJob,   'kublog/notification/email_job'
    autoload :Tweet,      'kublog/notification/tweet'
    autoload :TweetJob,   'kublog/notification/tweet_job'
    autoload :FbPost,     'kublog/notification/fb_post'
    autoload :FbPostJob,  'kublog/notification/fb_post_job'
  end
  
  module XhrUpload
    autoload :FileHelper, 'kublog/xhr_upload/file_helper'
  end
  
  mattr_accessor  :default_url_options
  @@default_url_options = {:host => 'www.example.com'}
  
  mattr_accessor  :user_kinds
  @@user_kinds = []
  
  mattr_reader    :notification_processing
  @@notification_processing = :immediately
  
  def self.notification_processing=(method='')
    @@notification_processing = method.to_sym
    if @@notification_processing == :delayed_job
      unless defined? Delayed::Job
        raise 'You must require delayed_job in your Gemfile to use this feature' 
      end
    end
  end
  
  KublogTwitter = Twitter.clone
  mattr_accessor  :twitter_client
  @@twitter_client = KublogTwitter::Client.new
  
  mattr_accessor  :facebook_client
  
  mattr_accessor  :blog_name
  @@blog_name = 'Kublog::Blog'
    
  def self.facebook_page_token=(token)
    @@facebook_client = FbGraph::User.me(token)
  end
  
  def self.setup
    yield self
  end
  
  def self.twitter
    yield @@twitter_client
  end
  
  def self.asset_path(path)
    ["/assets", self.root_path , path].join
  end
  
  def self.root_path
    Engine.routes.url_helpers.root_path
  end
  
  
end