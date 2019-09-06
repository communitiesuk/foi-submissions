# frozen_string_literal: true

task :copy_govuk_assets_without_compiling do
  cmd = [
    'cp',
    '-r',
    Rails.root.join('vendor', 'assets', 'govuk').to_s,
    Rails.root.join('public').to_s
  ]
  Kernel.system(*cmd)
end

Rake::Task['assets:precompile'].enhance do
  Rake::Task[:copy_govuk_assets_without_compiling].invoke
end
