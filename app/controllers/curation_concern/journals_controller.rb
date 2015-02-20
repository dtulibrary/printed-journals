# Generated via
#  `rails generate worthwhile:work Journals`

class CurationConcern::JournalsController < ApplicationController
  include Dtu::CurationConcernController
  set_curation_concern_type Journal
end
