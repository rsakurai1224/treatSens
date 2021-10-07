# SYNOPSIS
#
#   AX_COMPILER_EXT
#
# DESCRIPTION
#
#   Checks compiler for support for SIMD extensions.
#
#   This macro calls:
#
#     AC_SUBST(SSE2_FLAGS)
#     AC_SUBST(SSE4_1_FLAGS)
#     AC_SUBST(AVX_FLAGS)
#     AC_SUBST(AVX2_FLAGS)
#
#   And defines:
#
#     HAVE_MMX / HAVE_SSE / HAVE_SSE2
#     HAVE_SSE3 / HAVE_SSSE3 / HAVE_SSE4_1 / HAVE_SSE4_2 / HAVE_SSE4a
#     HAVE_AVX / HAVE_AVX2
#
# LICENSE
#
#   Copyright (c) 2007 Christophe Tournayre <turn3r@users.sourceforge.net>
#   Copyright (c) 2013,2015 Michael Petch <mpetch@capp-sysware.com>
#   Copyright (c) 2017 Rafael de Lucena Valle <rafaeldelucena@gmail.com>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.

#serial 1

AC_SUBST(SSE2_FLAG)
AC_SUBST(SSE4_1_FLAG)
AC_SUBST(AVX_FLAG)
AC_SUBST(AVX2_FLAG)

AC_DEFUN([AX_COMPILER_EXT],
[
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_REQUIRE([AC_PROG_CC])
  
  AC_REQUIRE([AX_CHECK_COMPILE_FLAG])
  
  SSE2_FLAG=""
  SSE4_1_FLAG=""
  AVX_FLAG=""
  AVX2_FLAG=""
  
  case $host_cpu in
  i[[3456]]86*|x86_64*|amd64*)
  
    case "$ax_cv_c_compiler_vendor" in
    sun)
      AC_CHECK_HEADER("xmmintrin.h",[
        ax_cv_support_sse2_ext=yes
        SSE2_FLAG="-xarch=sse2"
      ])
      AC_CHECK_HEADER("nmmintrin.h",[
        ax_cv_support_sse4_1_ext=yes
        SSE4_1_FLAG="-xarch=sse4_1"
      ])
      AC_CHECK_HEADER("immintrin.h",[
        ax_cv_support_avx_ext=yes
        AVX_FLAG="-xarch=avx"
      ])
      if test x$"ax_cv_support_avx_ext" = x"yes"; then
        AX_CHECK_COMPILE_FLAG("-xarch=avx2",[
          ax_cv_support_avx2_ext=yes
          AVX2_FLAG="-xarch=avx2"
        ])
      fi
      ;;
    
    *)
      AX_CHECK_COMPILE_FLAG(-msse2,[
        ax_cv_support_sse2_ext=yes
        SSE2_FLAG=-msse2
      ])
      AX_CHECK_COMPILE_FLAG(-msse4.1,[
        ax_cv_support_sse4_1_ext=yes
        SSE4_1_FLAG=-msse4.1
      ])
      AX_CHECK_COMPILE_FLAG(-mavx,[
        ax_cv_support_avx_ext=yes
        AVX_FLAG=-mavx
      ])
      if test x"$ax_cv_c_compiler_vendor" = x"intel"; then
        AX_CHECK_COMPILE_FLAG(-xcore-avx2,[
          ax_cv_support_avx2_ext=yes
          AVX2_FLAG=-xcore-avx2
        ])
      else
        AX_CHECK_COMPILE_FLAG(-mavx2,[
          ax_cv_support_avx2_ext=yes
          AVX2_FLAG=-mavx2
        ])
      fi
    ;;
    esac
  ;;
  esac
  
  if test x"$ax_cv_support_sse2_ext" = x"yes"; then
    AC_DEFINE(HAVE_SSE2,1,[Support SSE2 (Streaming SIMD Extensions 2) instructions])
  fi
 
  if test x"$ax_cv_support_sse41_ext" = x"yes"; then
    AC_DEFINE(HAVE_SSE4_1,1,[Support SSSE4.1 (Streaming SIMD Extensions 4.1) instructions])
  fi
  
  if test x"$ax_cv_support_avx_ext" = x"yes"; then
    AC_DEFINE(HAVE_AVX,1,[Support AVX (Advanced Vector Extensions) instructions])
  fi
  
  if test x"$ax_cv_support_avx2_ext" = x"yes"; then
    AC_DEFINE(HAVE_AVX2,1,[Support AVX2 (Advanced Vector Extensions 2) instructions])
  fi
  
  
  AH_TEMPLATE([HAVE_SSE2],[Define to 1 to support Streaming SIMD Extensions])
  AH_TEMPLATE([HAVE_SSE4_1],[Define to 1 to support Streaming SIMD Extensions 4.1])
  AH_TEMPLATE([HAVE_AVX],[Define to 1 to support Advanced Vector Extensions])
  AH_TEMPLATE([HAVE_AVX2],[Define to 1 to support Advanced Vector Extensions 2])
  
  AC_SUBST(SSE2_FLAG)
  AC_SUBST(SSE4_1_FLAG)
  AC_SUBST(AVX_FLAG)
  AC_SUBST(AVX2_FLAG)
])
