require 'builder'

module PartiesHelper
  
=begin rdoc
  Renders a name marked up in an HTML div, with last name
  rendered in one class, and all names before it in another.
  
  The intended use is that the +div+ serve as a banner of some kind, with an optional preamble string, followed by +span+s for prior-to-surnames (say, in a light font) and a surname (say, in a heavier font). The +div+ and the name +span+s carry attributes (such as +id+ or +class+) specified in a hash passed to +new+.
  
  The attribute hash is keyed by symbols, each mapping to a hash of the attributes for the corresponding element:
  
  div_params::      Hash, attributes for the div, each key-value pair an attribute name and the value
  given_params::    Hash, attributes for the before-last-name names, key-value = attr='value'
  surname_params::  Hash, attributes for the last-name names, key-value = attr='value'
  
  The name is split by whitespace, and rendered thus:
  
  - If an +extra+ string is supplied to +#markup_for+, it is emitted first.
  - Any whitespace-delimited substrings before the last are rejoined by spaces and wrapped in a +span+ with attributes from +given_params+
  - The last whitespace-delimited substring is treated as the surname, and wrapped in a +span+ with attributes from +surname_params+
  - The whole is wrapped in a +div+ with attributes from +div_params+
  
  If the person named is Indonesian, a Brazilian athlete, or an American pop star, and so has one name, it is rendered as though it were a surname.
=end
  
  class NameSplitter
    # Initialize with a hash for the attributes of the +div+ and +spans+.
    # The hash is optional, but it’s not very interesting -- no classes, no IDs.
    def initialize(args = nil)
      @params = args    # TODO: Work out some defaults
      @shared_builder = Builder::XmlMarkup.new
    end
    
    # Reset the splitter to make it ready to mark up fresh data.
    # Failing to do this will cause the marked-up output to accumulate.
    def clear
      @shared_builder = Builder::XmlMarkup.new
    end
    
    # Split a name by the whitespace and return an array containing
    # 0:: The parts before the last delimiter, joined by spaces
    # 1:: The part after the last delimiter
    def split_name(a_name = nil)
      return nil if ! a_name
      parts = a_name.split(/\s/)
      return nil if ! parts || parts.count == 0
    
      a_name = a_name.strip
    
      first_part = parts[0...-1].join ' '
      [first_part, parts[-1]]
    end
  
    # Return the complete markup for the banner +div+
    # 
    # === Parameters
    # a_name:: The name to split (optional, but returns nil)
    # extra:: A preamble string before the +span+ containing the given name(s)
    #
    # === Returns
    # nil:: If +a_name+ is nil (should raise a parameter exception instead)
    # string:: The markup for the +div+
    #
    # === Note
    # The string cannot be used as-is; it must be sent +#html_safe+ before it can be rendered in an +erb+.
    def markup_for(a_name = nil, extra='')
      return nil if ! a_name
    
      parts = self.split_name(a_name)
    
      b = @shared_builder
    
      if @params
        div_params = @params[:div_params]
        given_params = @params[:given_params]
        surname_params = @params[:surname_params]
      end
    
      b.div(div_params) do | div |
        b.text! extra if extra != ''
        if parts[0] != ""
          sp = b.span(given_params) {
            b.text! parts[0] + " "
          }
          puts sp
        end
        b.span(surname_params) {
          b.text! parts[1] 
        }
      end
      retval = b.target!
    end # markup_for 
  
  end #  class NameSplitter
  
  # Keep a single global splitter configured for the party-planner application
  # BUG: This should probably be a constant instead.
  $shared_splitter = NameSplitter.new div_params: { id: 'form-header' },
                                      given_params: { id: 'first-name'},
                                      surname_params: { id: 'last-name' }
  
  # Given a name, and optionally a preamble string, return them marked-up in a +div+.
  def name_markup(a_name, extra='')
    $shared_splitter.clear
    $shared_splitter.markup_for(a_name, extra).html_safe
  end
  
end #   module PartiesHelper
