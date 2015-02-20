# This is required by the OAI Provider in order to support encoding journal documents
class JournalFormat < OAI::Provider::Metadata::Format

  def initialize
    @prefix = 'jou'
    @schema = ''
    @namespace = 'http://ns.cvt.dk/journals/1.0'
    @element_namespace = 'jou'
    @fields = []
  end

  def encode(model, record)
    record.export_as_journal_xml
  end

  def header_specification
    {}
  end

end
