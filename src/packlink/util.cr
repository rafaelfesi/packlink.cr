struct Packlink
  struct Util
    def self.build_nested_query(
      value : Hash | NamedTuple,
      prefix : String? = nil
    )
      value.map do |k, v|
        escaped = prefix ? "#{prefix}[#{self.escape(k)}]" : self.escape(k)
        self.build_nested_query(v, escaped)
      end.reject(&.empty?).join("&")
    end

    def self.build_nested_query(
      value : Array(A::Scalar) | Array(Hash),
      prefix : String? = nil
    )
      value.map { |v| self.build_nested_query(v, "#{prefix}[]") }.join("&")
    end

    def self.build_nested_query(
      value : A::Scalar,
      prefix : String
    )
      "#{prefix}=#{self.escape(value.to_s)}"
    end

    def self.build_nested_query(
      value : Nil,
      prefix : String? = nil
    )
      prefix
    end

    def self.normalize_hash(value : Hash | NamedTuple)
      value.to_h.transform_keys(&.to_s)
    end

    private def self.escape(value : String | Symbol)
      URI.encode_www_form(value.to_s)
    end
  end
end
