class JournalDatastream < ActiveFedora::OmDatastream
    set_terminology do |t|
        t.root(path: "journal")
        t.id(:path=>{:attribute=>"id"}, index_as: :stored_searchable)
        t.title(index_as: :stored_searchable)
        t.title_alternative(index_as: :stored_searchable)
        t.title_previous(index_as: :stored_searchable)
        t.title_next(index_as: :stored_searchable)
        t.organisation(index_as: :stored_searchable)
        t.issn(index_as: :stored_searchable)
        t.coden(index_as: :stored_searchable)
        t.publisher(index_as: :stored_searchable)
        t.notes(index_as: :stored_searchable)
        t.holdings(index_as: :stored_searchable)
        t.physical_location {
            t.place(index_as: :stored_searchable)
            t.years(index_as: :stored_searchable)
            t.note(index_as: :stored_searchable)
        }
        t.z30 {
            t.sub_library(index_as: :displayable)
            t.collection(index_as: :displayable)
            t.shelf_code(index_as: :displayable)
            t.shelf_code2(index_as: :displayable)
            t.barcode(index_as: :displayable)
            t.open_date(index_as: :displayable)
            t.year(index_as: :displayable)
            t.volume(index_as: :displayable)
            t.issue(index_as: :displayable)
            t.part(index_as: :displayable)
            t.pages(index_as: :displayable)
            t.status(index_as: :displayable)
            t.status_text(index_as: :displayable)
            t.order_number(index_as: :displayable)
            t.description(index_as: :displayable)
            t.issue_date(index_as: :displayable)
            t.expected_date(index_as: :displayable)
            t.arrival_date(index_as: :displayable)
            t.type(index_as: :displayable)
            t.process_status(index_as: :displayable)
            t.price(index_as: :displayable)
            t.loans(index_as: :displayable)
        }
        t.issues
        t.hold {
            t.from_year
            t.from_volume
            t.from_issue
            t.to_year
            t.to_volume
            t.to_issue
            t.note
        }
        t.missing_issue {
            t.issue_year
            t.issue_volume
            t.issue_no
        }
        t.publication_date(index_as: [:stored_searchable, :facetable])
        t.type(path:"type", index_as: [:stored_searchable, :facetable])
    end

    def self.xml_template
        Nokogiri::XML.parse("<journal/>")
    end

    def prefix(ds_name)
        ""
    end
end
