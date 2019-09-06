# frozen_string_literal: true

task :copy_govuk_assets_without_compiling do
  cmd = [
    'cp',
    '-r',
    Rails.root.join('vendor', 'assets', 'govuk'),
    Rails.root.join('public')
  ]
  Kernel.system(*cmd)
end

Rake::Task['assets:precompile'].enhance do
  Rake::Task[:copy_govuk_assets_without_compiling].invoke
end
