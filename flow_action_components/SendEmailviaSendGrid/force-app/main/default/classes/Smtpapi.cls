global class Smtpapi {
  public Smtpapi() {}

  global class Header {
    public List<String> to = new List<String>();
    public Map<String, Object> sub = new Map<String, Object>();
    public Map<String, String> unique_args = new Map<String, String>();
    public List<String> category = new List<String>();
    public Map<String, String> section = new Map<String, String>();
    public Map<String, Map<String, Map<String,String>>> filters = new Map<String, Map<String, Map<String,String>>>();

    public Header() {}

    public Map<String, Object> toMap() {
      Map<String, Object> data = new Map<String, Object>();

      if (!this.to.isEmpty()) {
        data.put('to', this.to);
      }
      
      if (!this.sub.isEmpty()) {
        data.put('sub', this.sub);
      }
      
      if (!this.unique_args.isEmpty()) {
        data.put('unique_args', this.unique_args);
      }

      if (!this.category.isEmpty()) {
        data.put('category', this.category);
      }

      if (!this.section.isEmpty()) {
        data.put('section', this.section);
      }

      if (!this.filters.isEmpty()) {
        data.put('filters', this.filters);
      }

      return data;
    }

    public String jsonString() {
      Map<String, Object> data = this.toMap();
      return JSON.serialize(data);
    }

    public Header addTo(String to) {
      this.to.add(to);
      return this;
    }

    public Header setTos(List<String> tos) {
      this.to = tos;
      return this;
    }

    public Header addSubstitution(String key, List<String> val) {
      for (Integer i = 0; i < val.size(); i++) {
        List<String> val_in_array = new List<String> { val[i] };
        this.sub.put(key, val_in_array);
      }
      return this;
    }

    public Header setSubstitutions(Map<String, Object> substitutions) {
      this.sub = substitutions;
      return this;
    }

    public Header addUniqueArg(String key, String val) {
      this.unique_args.put(key, val);
      return this;
    }

    public Header setUniqueArgs(Map<String, String> unique_arguments) {
      this.unique_args = unique_arguments;
      return this;
    }

    public Header addCategory(String val) {
      this.category.add(val);
      return this;
    }

    public Header setCategories(List<String> categories) {
      this.category = categories;
      return this;
    }

    public Header addSection(String key, String val) {
      this.section.put(key, val);
      return this;
    }

    public Header setSections(Map<String, String> sections) {
      this.section = sections;
      return this;
    }

    public Header addFilter(String filter_name, String parameter_name, String parameter_value) {
      Map<String, Map<String,String>> filter_name_map;
      if (this.filters.get(filter_name) == null) {
        filter_name_map = new Map<String, Map<String,String>>();
        this.filters.put(filter_name, filter_name_map);
        this.filters.get(filter_name).put('settings', new Map<String,String>());
      }
      
      this.filters.get(filter_name).get('settings').put(parameter_name, parameter_value);
      
      return this;
    }

    public Header setFilters(Map<String, Map<String, Map<String,String>>> filters) {
      this.filters = filters;
      return this;
    }
  }
}