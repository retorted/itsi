# frozen_string_literal: true

require 'mkmf'
require 'rb_sys/mkmf'

create_rust_makefile('itsi/server/itsi_server') do |r|
  r.extra_rustflags = ['-C target-cpu=native']
  r.env = {
    'BINDGEN_EXTRA_CLANG_ARGS' => '-include stdbool.h -std=c99'
  }
end
