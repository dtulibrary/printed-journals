# -*- encoding : utf-8 -*-
require 'builder'
require 'metadata_format/journal_format'
BlacklightOaiProvider::SolrDocumentProvider.register_format(JournalFormat.instance)

# This module provides Journal export.  It is a replacement for BlacklightOaiProvider::SolrDocumentExtension
module JournalSolrDocumentExtension
  include HierarchicalAttributesHelper

  def self.extended(document)
    # Register our exportable formats
    JournalSolrDocumentExtension.register_export_formats( document )
  end

  def self.register_export_formats(document)
    document.will_export_as(:journal_xml, "text/xml")
  end

  def timestamp
    Time.parse get('timestamp')
  end

  # dublin core elements are mapped against the #dublin_core_field_names whitelist.
  def export_as_journal_xml
    cc = ActiveFedora::Base.find(self["id"])
    case cc.class.to_s
      when 'Journal'
        type = 'do'
      else
        type = 'do'
    end
    xml = Builder::XmlMarkup.new
    xml.tag!("mods",
             "xmlns"              => "http://www.loc.gov/mods/v3",
             "xmlns:xsi"          => "http://www.w3.org/2001/XMLSchema-instance",
             "xmlns:xlink"        => "http://www.w3.org/1999/xlink",
             "xsi:schemaLocation" => "http://oai.dads.dtic.dk/schema/mods-3-5-ds-dtic-dk-extended.xsd") do
      xml.genre('type'=>'ds.dtic.dk:type:synthesized') {
          xml.text! 'journal:print'
      }
      xml.titleInfo {
        xml.title('lang'=>'und') {
          xml.main cc.title
        }
      }
      xml.titleInfo('type'=>'alternative') {
        xml.title('lang'=>'und') {
          xml.main cc.title_alternative
        }
      }
      xml.titleInfo('type'=>'preceding') {
        xml.title('lang'=>'und') {
          xml.main cc.title_previous
        }
      }
      xml.titleInfo('type'=>'succeeding') {
        xml.title('lang'=>'und') {
          xml.main cc.title_next
        }
      }
      xml.identifier('type'=>'ds.dtic.dk:id:pub:dads:recordid') {
        xml.text! cc.id
      }
      xml.relatedItem('type'=>'host') {
        xml.titleInfo {
          xml.title('lang'=>'und') {
            xml.main cc.title
          }
        }
        if cc.issn
          xml.identifier('type'=>'ds.dtic.dk:id:pub:dads:pissn') {
            xml.text! cc.issn
          }
        end
        if cc.coden
          xml.identifier('type'=>'ds.dtic.dk:id:pub:coden') {
            xml.text! cc.coden
          }
        end
        if cc.organisation or cc.publisher
          xml.originInfo('eventType'=>'publisher') {
            if cc.organisation
              if cc.publisher
                xml.publisher cc.organisation + ', ' + cc.publisher
              else
                xml.publisher cc.organisation
              end
            else
              xml.publisher cc.publisher
            end
          }
        end
      }
      if cc.notes
        xml.note cc.notes
      end
#     xml.jou(:title) {
#       xml.jou(:original,"xml:lang"=>cc.lang) {
#         xml.jou(:main, cc.title)
#         cc.subtitle.each do |subtitle|
#           xml.jou(:sub, subtitle)
#         end
#       }
#     }
#     if cc.description or cc.keyword.length > 0
#       xml.jou(:description) {
#         xml.jou(:abstract, cc.description)
#         if cc.keyword.length > 0
#           xml.jou(:subject) {
#             cc.keyword.each do |kw|
#               xml.jou(:keyword, key_type:'fre') {
#                 xml.text! kw
#               }
#             end
#           }
#         end
#       }
#     end
#     hierarchical_attribute_collection(cc, :person).each do |person|
#       xml.jou(:person, pers_role:person.role.first) {
#         xml.jou(:name) {
#           xml.jou(:first, person.first_name.first)
#           xml.jou(:last,  person.last_name.first)
#         }
#       }
#     end
#     hierarchical_attribute_collection(cc, :organisation).each do |org|
#       xml.jou(:organisation, pers_role:org.role.first) {
#         xml.jou(:name) {
#           xml.jou(:level1, org.level1.first)
#           xml.jou(:level2, org.level2.first)
#           xml.jou(:level3, org.level3.first)
#           xml.jou(:level4, org.level4.first)
#         }
#       }
#     end
#     cc.requester.each do |req|
#       xml.jou(:local_field, tag_type:'4') {
#         xml.jou(:code, 'requester')
#         xml.jou(:data, req)
#       }
#     end
#     xml.jou(:publication) {
#       if cc.linked_resources.present?
#         cc.linked_resources.each do |link|
#           xml.jou(:inetpub) {
#             if link.title and link.title.length > 0
#               xml.jou(:text, link.title)
#             else
#               xml.jou(:text, link.url)
#             end
#             xml.jou(:url, link.url)
#           }
#         end
#       end
#       cc.generic_files.each do |file|
#         hash = file.to_solr.stringify_keys
#         access = 'na'
#         if hash[Hydra.config.permissions.read.group].present?
#           if hash[Hydra.config.permissions.read.group].include?('public')
#             if hash[Hydra.config.permissions.embargo.release_date].present?
#               access = 'ea'
#             else
#               access = 'oa'
#             end
#           elsif hash[Hydra.config.permissions.read.group].include?('registered')
#             access = 'ca'
#           end
#         end
#         xml.jou(:digital_object, id: file.pid, access: access) {
#           xml.jou(:file, filename: file.title.first)
#           xml.jou(:uri, "http://missingStuff.dtic.dk/downloads/#{file.pid}")
#         }
#       end
#     }
    end
  end
end
