MRuby::Build.new('host-bbsruby-fullcore') do |conf|
  # load specific toolchain settings
  conf.toolchain

  # Turn on `enable_debug` for better debugging
  conf.enable_debug

  # include the GEM box
  conf.gembox 'full-core'

  # C compiler settings
  conf.cc do |cc|
    cc.flags = '-fPIC'
    cc.defines = %w(MRB_USE_DEBUG_HOOK BBSRUBY_MRUBY_HAS_FULLCORE_GEMBOX)
  end

  # Generate mruby debugger command (require mruby-eval)
  conf.gem :core => "mruby-error"
end
