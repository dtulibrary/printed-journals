class CatalogController < ApplicationController
  include Worthwhile::CatalogController
  include ::BlacklightOaiProvider::ControllerExtension

  configure_blacklight do |config|
    config.oai = {
        :repository_url => 'http://localhost',
        :provider => {
            :repository_name => "Findit Local",
            :repository_url => 'http://localhost',
            :record_prefix => '',
            :admin_email => 'root@localhost'
        },
        :document => {
            :timestamp => 'timestamp',
            :limit => 25
        }
    }
    config.default_solr_params = {
      :qf => 'id_tesim title_tesim title_alternative_tesim title_previous_tesim title_next_tesim issn_tesim coden_tesim publisher_tesim notes_tesim holdings_tesim physical_location_place_tesim physical_location_years_tesim physical_location_note_tesim',
      :qt => 'search',
      :rows => 10
    }
    config.search_fields = {};
    config.add_search_field('all_fields', :label => 'All Fields') do |field|
        field.solr_local_parameters = {
            :qf => 'id title_tesim title_alternative_tesim title_previous_tesim title_next_tesim issn_tesim coden_tesim publisher_tesim notes_tesim holdings_tesim physical_location_place_tesim physical_location_years_tesim physical_location_note_tesim organisation_tesim',
            :pf => 'title_tesim',
        }
    end
    config.add_search_field('title', :label => 'Title') do |field|
        field.solr_local_parameters = {
            :qf => 'title_tesim',
            :pf => 'title_tesim',
        }
    end
    config.add_search_field('title_alternative', :label => 'Alternative title') do |field|
        field.solr_local_parameters = {
            :qf => 'title_alternative_tesim title_previous_tesim title_next_tesim',
            :pf => 'title_alternative_tesim',
        }
    end
    config.add_search_field('issn', :label => 'ISSN') do |field|
        field.solr_local_parameters = {
            :qf => 'issn_tesim',
            :pf => 'issn_tesim',
        }
    end
    config.add_search_field('publisher', :label => 'Publisher') do |field|
        field.solr_local_parameters = {
            :qf => 'publisher_tesim',
            :pf => 'publisher_tesim',
        }
    end
    config.add_search_field('place', :label => 'Location') do |field|
        field.solr_local_parameters = {
            :qf => 'physical_location_place_tesim',
            :pf => 'physical_location_place_tesim',
        }
    end
    config.add_search_field('years', :label => 'Years') do |field|
        field.solr_local_parameters = {
            :qf => 'physical_location_years_tesim',
            :pf => 'physical_location_years_tesim',
        }
    end
    config.add_search_field('note', :label => 'Notes') do |field|
        field.solr_local_parameters = {
            :qf => 'physical_location_note_tesim',
            :pf => 'physical_location_note_tesim',
        }
    end
  end
  # get search results from the solr index
  # Overriding this method in order to enable rendering of OAI-PMH responses when .oaipmh is the requested format
  def index
    respond_to do |format|
      format.html {
        if params['f'].nil?
          params['f'] = {'generic_type_sim' => ['Work']}
        end
      }
    end
    (@response, @document_list) = get_search_results
    respond_to do |format|
      format.html { }
      format.rss  { render :layout => false }
      format.atom { render :layout => false }
      format.oaipmh { render :layout => false }     # <-- This is the only line that we actually want to override.
      format.json do
        render json: render_search_results_as_json
      end

      additional_response_formats(format)
      document_export_formats(format)
    end
  end
end
