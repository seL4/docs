# Copyright 2018 Thomes Darde
# SPDX-License-Identifier: MIT

# Obtained from:
# https://github.com/guard/listen/wiki/Duplicate-directory-errors
require 'listen/record/symlink_detector'
module Listen
  class Record
    class SymlinkDetector
      def _fail(_, _)
        fail Error, "Don't watch locally-symlinked directory twice"
      end
    end
  end
end
