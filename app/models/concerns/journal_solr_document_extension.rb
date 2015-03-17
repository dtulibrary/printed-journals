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
      cc.title_alternative.each do |title|
        xml.titleInfo('type'=>'alternative') {
          xml.title('lang'=>'und') {
            xml.main title
          }
        }
      end
      cc.title_previous.each do |title|
        xml.titleInfo('type'=>'preceding') {
          xml.title('lang'=>'und') {
            xml.main title
          }
        }
      end
      cc.title_next.each do |title|
        xml.titleInfo('type'=>'succeeding') {
          xml.title('lang'=>'und') {
            xml.main title
          }
        }
      end
      xml.identifier('type'=>'ds.dtic.dk:id:pub:dads:recordid') {
        xml.text! cc.id
      }
      xml.relatedItem('type'=>'host') {
        xml.titleInfo {
          xml.title('lang'=>'und') {
            xml.main cc.title
          }
        }
        cc.issn.each do |issn|
          xml.identifier('type'=>'ds.dtic.dk:id:pub:dads:pissn') {
            xml.text! issn
          }
        end
        cc.coden.each do |coden|
          xml.identifier('type'=>'ds.dtic.dk:id:pub:coden') {
            xml.text! coden
          }
        end
        i=0
        while 1
          if cc.organisation[i] or cc.publisher[i]
            xml.originInfo('eventType'=>'publisher') {
              if cc.organisation[i]
                if cc.publisher[i]
                  xml.publisher cc.organisation[i] + ', ' + cc.publisher[i]
                else
                  xml.publisher cc.organisation[i]
                end
              else
                xml.publisher cc.publisher[i]
              end
            }
            i += 1
          else
            break
          end
        end
      }
      cc.notes.each do |note|
        xml.note note
      end
      place = []
      hierarchical_attribute_collection(cc, :physical_location).each do |phys|
        place = phys.place.first.split(' : ')
        if place[0] == 'MAG'
          place[0] = 'DTU Library, Lyngby, Closed stacks'
        else
          place[0] = 'DTU Library, Lyngby, Open stacks'
        end
        break
      end
      xml.location {
        xml.holdingExternal {
          xml.holding('xmlns:iso20775'=>'info:ofi/fmt:xml:xsd:iso20775', 'xsi:schemaLocation'=>'info:ofi/fmt:xml:xsd:iso20775 http://www.loc.gov/standards/iso20775/N130_ISOholdings_v6_1.xsd') {
            xml.holdingStructured {
              hierarchical_attribute_collection(cc, :hold).each do |hold|
                xml.set {
                  xml.sublocation place[0]
                  xml.shelfLocator place[1]
                  xml.enumerationAndChronology {
                    xml.startingEnumAndChronology {
                      xml.structured {
                        xml.chronology {
                          xml.value hold.from_year.first
                        }
                        xml.enumeration {
                          xml.level 1
                          xml.caption 'vol'
                          xml.value hold.from_volume.first
                        }
                        xml.enumeration {
                          xml.level 2
                          xml.caption 'iss'
                          xml.value hold.from_issue.first
                        }
                      }
                    }
                    xml.endingEnumAndChronology {
                      xml.structured {
                        xml.chronology {
                          xml.value hold.to_year.first
                        }
                        xml.enumeration {
                          xml.level 1
                          xml.caption 'vol'
                          xml.value hold.to_volume.first
                        }
                        xml.enumeration {
                          xml.level 2
                          xml.caption 'iss'
                          xml.value hold.to_issue.first
                        }
                      }
                    }
                  }
                }
              end
            
            }
          }
        }
      }
    end
  end
end
