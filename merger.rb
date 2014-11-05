require 'byebug'

HASH_ONE =  {"user"=>{"address"=>{"street"=>"main"}}}
HASH_TWO =  {"user"=>{"address"=>{"zip"=>"89436"}}}

def merge_hashes(hash1, hash2)
  # Base case: one of the hashes doesn't contain subhashes
  return hash1.merge(hash2) if !hash1.has_hash? || !hash2.has_hash?

  final_hash = {}
  key_set1, key_set2 = hash1.keys, hash2.keys

  key_set1.each_with_index do |key, i|

    if hash1[key].is_a?(Hash) && hash2[key].is_a?(Hash)

      final_hash[key] = merge_hashes(hash1[key], hash2[key])

    elsif hash1[key].is_a?(Hash) && !hash2[key_set2[i]].is_a?(Hash)

      final_hash.merge!(hash1[key].merge(hash2[key_set2[i]]))
    end
  end

  final_hash
end

class Hash
  def has_hash?
    self.values.any? { |val| val.is_a?(Hash) }
  end
end
