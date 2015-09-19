
"""
Copies ezEngine files to krepel in a post-build step of ez
"""

import argparse
from pathlib import *
from distutils.dir_util import copy_tree, mkpath
from distutils.file_util import copy_file


suffixes = {
  "Debug" :          "-debug",
  "MinSizeRel" :     "-minsize",
  "RelWithDebInfo" : "-reldeb",
  "Release" :        "",
}

bin_extenstions = [".exe", ".dll", ".pdb", ".so"]

lib_extenstions = [".lib", ".exp", ".dylib"]


def get_args():
  """Get arguments to this script."""
  parser = argparse.ArgumentParser(description='Copy ezEngine files to the Krepel dir.')
  parser.add_argument('targets',
                      metavar='T',
                      nargs='+',
                      help='an integer for the accumulator')
  parser.add_argument("--ezDir",
                      type=Path,
                      help="Root directory of the ezEngine installation.")
  parser.add_argument("--ezBinDir",
                      type=Path,
                      help="ezEngine Bin dir.")
  parser.add_argument("--ezLibDir",
                      type=Path,
                      help="ezengine Lib dir.")
  parser.add_argument("--krEzCodeDestDir",
                      type=Path,
                      help="Destination dir for the ezEngine source files for the given targets.")
  parser.add_argument("--krBinDir",
                      type=Path,
                      help="Krepel bin dir.")
  parser.add_argument("--krLibDir",
                      type=Path,
                      help="Krepel lib dir.")
  parser.add_argument("--config",
                      choices=suffixes.keys(),
                      help="The configuration that was built.")
  parser.add_argument("-n", "--dry-run",
                      type=bool,
                      default=False,
                      help="Just show what would be done instead of actually doing it.")
  parser.add_argument("-v", "--verbose",
                      action="store_true",
                      default=True,
                      help="Do not be quiet.")
  parser.add_argument("-q", "--quiet",
                      dest="verbose",
                      default=False,
                      action="store_false",
                      help="Be quiet.")

  return parser.parse_args()


def copy_code(*, src_path, dst_path, verbose, dry_run):
  """Copy ezEngine code to krepel."""
  if verbose:
    print("{}/ => {}/".format(src_path.as_posix(), dst_path.as_posix()))
  copy_tree(src=src_path.as_posix(),
            dst=dst_path.as_posix(),
            update=True,
            dry_run=dry_run)


def copy_output_files(*, targets, extensions, src_path, dst_path, suffix, verbose, dry_run):
  """Copy ezEngine binaries to krepel bin dir"""
  for target in targets:
    for ext in extensions:
      file_name = "ez{}{}{}".format(target, suffix, ext)
      src = src_path / file_name
      if not src.is_file():
        continue
      dst = dst_path / file_name
      if verbose:
        print("{} => {}".format(src.as_posix(), dst.as_posix()))
      mkpath(dst.parent.as_posix(),
             dry_run=dry_run)
      copy_file(src=src.as_posix(),
                dst=dst.as_posix(),
                update=True,
                dry_run=dry_run)


def main():
  """Entry point."""
  args = get_args()
  if args.verbose:
    print("ezEngine targets: {}".format(args.targets))
  suffix = suffixes[args.config]
  copy_code(src_path=args.ezDir / "Code" / "Engine",
            dst_path=args.krEzCodeDestDir,
            verbose=args.verbose,
            dry_run=args.dry_run)
  copy_output_files(targets=args.targets,
                    extensions=bin_extenstions,
                    src_path=args.ezBinDir,
                    dst_path=args.krBinDir,
                    suffix=suffix,
                    verbose=args.verbose,
                    dry_run=args.dry_run)
  copy_output_files(targets=args.targets,
                    extensions=lib_extenstions,
                    src_path=args.ezLibDir,
                    dst_path=args.krLibDir,
                    suffix=suffix,
                    verbose=args.verbose,
                    dry_run=args.dry_run)

if __name__ == '__main__':
  main()
