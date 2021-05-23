MRuby::Build.new('host-bbsruby') do |conf|
  # load specific toolchain settings
  conf.toolchain

  conf.enable_debug

  # include the default GEMs
  conf.gembox 'default'

  # C compiler settings
  conf.cc do |cc|
    cc.flags = '-fPIC'
    cc.defines = %w(MRB_USE_DEBUG_HOOK)
  end

  # Generate mruby debugger command (require mruby-eval)
  conf.gem :core => "mruby-error"
end
