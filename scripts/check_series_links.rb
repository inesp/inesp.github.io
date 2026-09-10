#!/usr/bin/env ruby
# Checks that every prev_post/next_post in _posts front matter points to a
# real post file, and that every link is reciprocal (A->next->B implies
# B->prev->A). Run standalone (not a Jekyll plugin) because the github-pages
# gem forces safe mode, which disables custom Jekyll plugins entirely.

require "yaml"

posts_dir = File.expand_path("../_posts", __dir__)
files = Dir.glob(File.join(posts_dir, "*.md"))
slugs = files.map { |f| File.basename(f, ".md") }

front_matter = {}
files.each do |f|
  content = File.read(f)
  if content.start_with?("---")
    _, fm, = content.split(/^---\s*$/, 3)
    front_matter[File.basename(f, ".md")] = YAML.safe_load(fm) || {}
  end
end

errors = []

front_matter.each do |slug, data|
  %w[prev_post next_post].each do |field|
    ref = data[field]
    next unless ref
    ref = ref.to_s
    unless slugs.include?(ref)
      errors << "#{slug}: #{field} -> '#{ref}' does not match any post file"
    end
  end
end

front_matter.each do |slug, data|
  next_ref = data["next_post"]&.to_s
  next unless next_ref && slugs.include?(next_ref)
  back = front_matter[next_ref]&.dig("prev_post")&.to_s
  if back != slug
    errors << "#{slug} -> next_post -> #{next_ref}, but #{next_ref}'s prev_post is #{back.inspect} (expected #{slug.inspect})"
  end
end

if errors.any?
  warn "Broken series links found:"
  errors.each { |e| warn "  #{e}" }
  exit 1
else
  puts "All series links check out (#{files.length} posts scanned)."
end
