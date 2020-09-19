# Ruby helper for attribs

def all_attribs
  json('/tmp/.all_attributes.json').params
end

def cpu_attribs
  json('/tmp/.specific_attributes.json').params
end

def mem_attribs
  json('/tmp/.specific_attributes.json').params
end

def memtotal
  mem_attribs['meminfo']['total'].to_i
end
