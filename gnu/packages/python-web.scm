;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015 Eric Dvorsak <eric@dvorsak.fr>
;;; Copyright © 2015, 2016, 2017 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2017 Christopher Baines <mail@cbaines.net>
;;; Copyright © 2016, 2017 Danny Milosavljevic <dannym+a@scratchpost.org>
;;; Copyright © 2013, 2014, 2015, 2016 Andreas Enge <andreas@enge.fr>
;;; Copyright © 2016, 2017 Marius Bakke <mbakke@fastmail.com>
;;; Copyright © 2015, 2016, 2017, 2018 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2017 Roel Janssen <roel@gnu.org>
;;; Copyright © 2016, 2017 Julien Lepiller <julien@lepiller.eu>
;;; Copyright © 2016, 2017 Nils Gillmann <ng0@n0.is>
;;; Copyright © 2014, 2017 Eric Bavier <bavier@member.fsf.org>
;;; Copyright © 2014, 2015 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2015 Cyril Roelandt <tipecaml@gmail.com>
;;; Copyright © 2015, 2016, 2017 Leo Famulari <leo@famulari.name>
;;; Copyright © 2016 Hartmut Goebel <h.goebel@crazy-compilers.com>
;;; Copyright © 2016, 2017, 2018 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2015, 2017 Ben Woodcroft <donttrustben@gmail.com>
;;; Copyright © 2015, 2016 Christopher Allan Webber <cwebber@dustycloud.org>
;;; Copyright © 2017 Adriano Peluso <catonano@gmail.com>
;;; Copyright © 2016 Dylan Jeffers <sapientech@sapientech@openmailbox.org>
;;; Copyright © 2016 David Craven <david@craven.ch>
;;; Copyright © 2017 Oleg Pykhalov <go.wigust@gmail.com>
;;; Copyright © 2015, 2016 David Thompson <davet@gnu.org>
;;; Copyright © 2017 Mark Meyer <mark@ofosos.org>
;;; Copyright © 2018 Tomáš Čech <sleep_walker@gnu.org>
;;; Copyright © 2018 Nicolas Goaziou <mail@nicolasgoaziou.fr>
;;; Copyright © 2018 Mathieu Othacehe <m.othacehe@gmail.com>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu packages python-web)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system python)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages check)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages django)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages time)
  #:use-module (gnu packages xml)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (srfi srfi-1))

(define-public python-aiohttp
  (package
    (name "python-aiohttp")
    (version "3.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "aiohttp" version))
       (sha256
        (base32
         "1b888lggmyf2d08rfayq9khszzc0pav1z70ssc0b4d9kkr4g1klz"))))
    (build-system python-build-system)
    (arguments
     `(#:tests? #f))                    ;FIXME: 2 errors, 2084 passed
    (native-inputs
     `(("python-async-generator" ,python-async-generator)
       ("python-pytest" ,python-pytest)
       ("python-pytest-capturelog" ,python-pytest-capturelog)
       ("python-pytest-mock" ,python-pytest-mock)))
    (propagated-inputs
     `(("python-aiodns" ,python-aiodns)
       ("python-async-timeout" ,python-async-timeout)
       ("python-attrs" ,python-attrs)
       ("python-chardet" ,python-chardet)
       ("python-idna-ssl" ,python-idna-ssl)
       ("python-multidict" ,python-multidict)
       ("python-yarl" ,python-yarl)))
    (home-page "https://github.com/aio-libs/aiohttp/")
    (synopsis "Async HTTP client/server framework (asyncio)")
    (description "@code{aiohttp} is an asynchronous HTTP client/server
framework.

Its main features are:
@itemize
@item Supports both client and server side of HTTP protocol.
@item Supports both client and server Web-Sockets out-of-the-box without the
Callback Hell.
@item Web-server has middlewares and pluggable routing.
@end itemize")
    (license license:asl2.0)))

(define-public python-aiodns
  (package
    (name "python-aiodns")
    (version "1.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "aiodns" version))
       (sha256
        (base32
         "1snr5paql8dgvc676n8xq460wypjsb1xj53cf3px1s4wczf7lryq"))))
    (build-system python-build-system)
    (inputs
     `(("python-pycares" ,python-pycares)))
    (arguments
     `(#:tests? #f))                    ;tests require internet access
    (home-page "http://github.com/saghul/aiodns")
    (synopsis "Simple DNS resolver for asyncio")
    (description "@code{aiodns} provides a simple way for doing
asynchronous DNS resolutions with a synchronous looking interface by
using @url{https://github.com/saghul/pycares,pycares}.")
    (license license:expat)))

(define-public python-furl
  (package
    (name "python-furl")
    (version "0.5.6")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "furl" version))
        (sha256
          (base32
            "0lzpfpm686hvz3sr1mcrnd1b3lgmnw8v59gb43wfi98r3b671pqc"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-six" ,python-six)
       ("python-orderedmultidict" ,python-orderedmultidict)))
    (native-inputs
     `(("python-pycodestyle" ,python-pycodestyle)))
    (home-page "https://github.com/gruns/furl")
    (synopsis "URL manipulation in Python")
    (description "Furl provides an easy-to-use alternative to the
@code{urllib} and @code{urlparse} modules for manipulating URLs.")
    (license license:unlicense)))

(define-public python2-furl
  (package-with-python2 python-furl))

(define-public python-httplib2
  (package
    (name "python-httplib2")
    (version "0.9.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "httplib2" version))
       (sha256
        (base32
         "126rsryvw9vhbf3qmsfw9lf4l4xm2srmgs439lgma4cpag4s3ay3"))))
    (build-system python-build-system)
    (home-page "https://github.com/jcgregorio/httplib2")
    (synopsis "Comprehensive HTTP client library")
    (description
     "A comprehensive HTTP client library supporting many features left out of
other HTTP libraries.")
    (license license:expat)))

(define-public python2-httplib2
  (package-with-python2 python-httplib2))

(define-public python-sockjs-tornado
  (package
    (name "python-sockjs-tornado")
    (version "1.0.5")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "sockjs-tornado" version))
       (sha256
        (base32
         "0zhq8wnnhkfbvdnsggqrc3pp97pqpilsf7fh6ymvnf52r0rwyjsc"))))
    (build-system python-build-system)
    (arguments
     `(;; There are no tests, and running the test phase requires missing
       ;; dependencies
       #:tests? #f))
    (propagated-inputs
     `(("python-tornado" ,python-tornado)))
    (home-page "https://github.com/mrjoes/sockjs-tornado/")
    (synopsis
     "SockJS Python server implementation on top of the Tornado framework")
    (description
     "SockJS-tornado provides the server-side counterpart to a SockJS client
library, through the Tornado framework.

SockJS provides a low-latency, full-duplex, cross-domain communication channel
between a web browser and web server.")
    (license license:expat)))

(define-public python2-sockjs-tornado
  (package-with-python2 python-sockjs-tornado))

(define-public python-flask-babel
  (package
    (name "python-flask-babel")
    (version "0.11.2")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "Flask-Babel" version))
        (sha256
          (base32
            "0ff9n165vhf1nhv6807ckhpp224jw7k7sd7jz5kfh3sbpl85gmy0"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-flask" ,python-flask)
       ("python-babel" ,python-babel)
       ("python-jinja2" ,python-jinja2)
       ("python-pytz" ,python-pytz)))
    (home-page "https://github.com/python-babel/flask-babel")
    (synopsis "Add i18n/l10n support to Flask applications")
    (description "This package implements internationalization and localization
support for Flask.  This is based on the Python babel module as well as pytz -
both of which are installed automatically if you install this library.")
    (license license:bsd-3)))

(define-public python2-flask-babel
  (package-with-python2 python-flask-babel))

(define-public python-html5lib
  (package
    (name "python-html5lib")
    (version "1.0.1")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "html5lib" version))
        (sha256
          (base32
            "0dipzfrycv6j1jw82v9b7d8lzggx3x8xngx6l4xrqkxwvg7hvjv6"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-six" ,python-six)
       ("python-webencodings" ,python-webencodings)))
    (arguments
     `(#:test-target "check"))
    (home-page
      "https://github.com/html5lib/html5lib-python")
    (synopsis
      "Python HTML parser based on the WHATWG HTML specifcation")
    (description
      "Html5lib is an HTML parser based on the WHATWG HTML specifcation
and written in Python.")
    (license license:expat)))

(define-public python2-html5lib
  (package-with-python2 python-html5lib))

;; Needed for python-bleach, a dependency of python-notebook
(define-public python-html5lib-0.9
  (package
    (inherit python-html5lib)
    (version "0.999")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "html5lib" version))
       (sha256
        (base32
         "17n4zfsj6ynmbwdwviywmj8r6nzr3xvfx2zs0xhndmvm51z7z263"))))))

(define-public python2-html5lib-0.9
  (package-with-python2 python-html5lib-0.9))

(define-public python-html5-parser
  (package
    (name "python-html5-parser")
    (version "0.4.5")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "html5-parser" version))
              (sha256
               (base32
                "01mx33sx4dhl4kj6wc48nj6jz7ry60rkhjv0s6k8h5xmjf5yy0x9"))))
    (build-system python-build-system)
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("libxml2" ,libxml2)))
    (propagated-inputs
     `(("python-lxml" ,python-lxml)
       ("python-beautifulsoup4" ,python-beautifulsoup4)))
    (home-page "https://html5-parser.readthedocs.io")
    (synopsis "Fast C-based HTML5 parsing for Python")
    (description "This package provides a fast implementation of the HTML5
parsing spec for Python.  Parsing is done in C using a variant of the gumbo
parser.  The gumbo parse tree is then transformed into an lxml tree, also in
C, yielding parse times that can be a thirtieth of the html5lib parse times.")
    ;; src/as-python-tree.[c|h] are licensed GPL3.  The other files
    ;; indicate ASL2.0, including the LICENSE file for the whole project.
    (license (list license:asl2.0 license:gpl3))))

(define-public python2-html5-parser
  (package-with-python2 python-html5-parser))

(define-public python-pycurl
  (package
    (name "python-pycurl")
    (version "7.43.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.bintray.com/pycurl/pycurl/pycurl-"
                           version ".tar.gz"))
       (sha256
        (base32 "1915kb04k1j4y6k1dx1sgnbddxrl9r1n4q928if2lkrdm73xy30g"))))
    (build-system python-build-system)
    (arguments
     ;; The tests attempt to access external web servers, so we cannot run
     ;; them.  Furthermore, they are skipped altogether when using Python 2.
     '(#:tests? #f))
    (native-inputs
     `(("python-nose" ,python-nose)
       ("python-bottle" ,python-bottle)))
    (inputs
     `(("curl" ,curl)
       ("gnutls" ,gnutls)))
    (home-page "http://pycurl.io/")
    (synopsis "Lightweight Python wrapper around libcurl")
    (description "Pycurl is a lightweight wrapper around libcurl.  It provides
high-speed transfers via libcurl and frequently outperforms alternatives.")

    ;; Per 'README.rst', this is dual-licensed: users can redistribute pycurl
    ;; under the terms of LGPLv2.1+ or Expat.
    (license (list license:lgpl2.1+ license:expat))))

(define-public python2-pycurl
  (package-with-python2 python-pycurl))

(define-public python-webencodings
  (package
    (name "python-webencodings")
    (version "0.5.1")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "webencodings" version))
              (sha256
               (base32
                "08qrgrc4hrximb2gqnl69g01s93rhf2842jfxdjljc1dbwj1qsmk"))))
    (build-system python-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda _
             (invoke "py.test" "-v" "webencodings/tests.py")
             #t)))))
    (native-inputs
     `(("python-pytest" ,python-pytest)))
    (home-page "https://github.com/SimonSapin/python-webencodings")
    (synopsis "Character encoding aliases for legacy web content")
    (description
     "In order to be compatible with legacy web content when interpreting
something like @code{Content-Type: text/html; charset=latin1}, tools need
to use a particular set of aliases for encoding labels as well as some
overriding rules.  For example, @code{US-ASCII} and @code{iso-8859-1} on
the web are actually aliases for @code{windows-1252}, and a @code{UTF-8}
or @code{UTF-16} BOM takes precedence over any other encoding declaration.
The WHATWG @url{https://encoding.spec.whatwg.org/,Encoding} standard
defines all such details so that implementations do not have to
reverse-engineer each other.

This module implements the Encoding standard and has encoding labels and
BOM detection, but the actual implementation for encoders and decoders
is Python’s.")
    (license license:bsd-3)))

(define-public python2-webencodings
  (package-with-python2 python-webencodings))

(define-public python-openid
  (package
    (name "python-openid")
    (version "3.0.10")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "python3-openid" version))
       (sha256
        (base32
         "1x3nh3fycqfn43jp5j5pb4q4y2jxp4mdka4absaa3bc0078qd758"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
        (replace 'check
          (lambda _
            (invoke "./admin/runtests")
            #t)))))
    (properties `((python2-variant . ,(delay python2-openid))))
    (propagated-inputs
     `(("python-defusedxml" ,python-defusedxml)))
    (native-inputs
     `(("python-psycopg2" ,python-psycopg2)
       ("python-django" ,python-django)))
    (home-page "https://github.com/necaris/python3-openid")
    (synopsis "OpenID support for servers and consumers")
    (description "This library provides OpenID authentication for Python, both
for clients and servers.")
    (license license:asl2.0)))

(define-public python2-openid
  (package
    (name "python2-openid")
    (version "2.2.5")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "python-openid" version))
       (sha256
        (base32
         "1vvhxlghjan01snfdc4k7ykd80vkyjgizwgg9bncnin8rqz1ricj"))))
    (build-system python-build-system)
    (arguments
     ;; Python 3 support is in `python3-openid`, a separate package.
     `(#:python ,python-2))
    (home-page "https://github.com/openid/python-openid")
    (synopsis "OpenID support for servers and consumers")
    (description "This library provides OpenID authentication for Python, both
for clients and servers.")
    (license license:asl2.0)))

(define-public python-cssutils
  (package
    (name "python-cssutils")
    (version "1.0.2")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "cssutils" version))
        (sha256
         (base32
          "1bxchrbqzapwijap0yhlxdil1w9bmwvgx77aizlkhc2mcxjg1z52"))))
    (build-system python-build-system)
    (native-inputs
     `(("unzip" ,unzip)))               ; for unpacking the source
    (arguments
     `(#:tests? #f))                    ; tests require python-pbr < 1.7.0
    (home-page "http://cthedot.de/cssutils/")
    (synopsis
      "CSS Cascading Style Sheets library for Python")
    (description
      "Cssutils is a Python package for parsing and building CSS
Cascading Style Sheets.  Currently it provides a DOM only and no rendering
options.")
    (license license:lgpl3+)))

(define-public python2-cssutils
  (package-with-python2 python-cssutils))

(define-public python-cssselect
  (package
    (name "python-cssselect")
    (version "0.9.2")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "cssselect" version))
        (sha256
         (base32
          "1xg6gbva1yswghiycmgincv6ab4bn7hpm720ndbj40h8xycmnfvi"))))
    (build-system python-build-system)
    (arguments
     ;; tests fail with message
     ;; AttributeError: 'module' object has no attribute 'tests'
     `(#:tests? #f))
    (home-page
      "https://pythonhosted.org/cssselect/")
    (synopsis
      "CSS3 selector parser and translator to XPath 1.0")
    (description
      "Cssselect ia a Python module that parses CSS3 Selectors and translates
them to XPath 1.0 expressions.  Such expressions can be used in lxml or
another XPath engine to find the matching elements in an XML or HTML document.")
    (license license:bsd-3)))

(define-public python2-cssselect
  (package-with-python2 python-cssselect))

(define-public python-openid-cla
  (package
    (name "python-openid-cla")
    (version "1.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "python-openid-cla" version))
       (sha256
        (base32
         "102hy2qisvjxp5s0v9lvwqi4f2dk0dhns40vjgn008yxc7k0h3cr"))))
    (build-system python-build-system)
    (arguments '(#:tests? #f)) ; No tests.
    (home-page "https://github.com/puiterwijk/python-openid-cla/")
    (synopsis "Implementation of the OpenID CLA extension for python-openid")
    (description "@code{openid-cla} is an implementation of the OpenID
contributor license agreement extension for python-openid.")
    (license license:bsd-3)))

(define-public python2-openid-cla
  (package-with-python2 python-openid-cla))

(define-public python-openid-teams
  (package
    (name "python-openid-teams")
    (version "1.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "python-openid-teams" version))
       (sha256
        (base32
         "05zrh78alav24rxkbqlpbad6d3x2nljk6z6j7kflxf3vdqa7w969"))))
    (build-system python-build-system)
    (arguments '(#:tests? #f)) ; No tests.
    (home-page "https://github.com/puiterwijk/python-openid-teams/")
    (synopsis "Implementation of the OpenID teams extension for python-openid")
    (description
     "@code{openid-teams} is an implementation of the OpenID
teams extension for python-openid.")
    (license license:bsd-3)))

(define-public python2-openid-teams
  (package-with-python2 python-openid-teams))

(define-public python-tornado
  (package
    (name "python-tornado")
    (version "4.5.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "tornado" version))
       (sha256
        (base32 "1zbkgcdfq81k298awrm8p0xwbwwn2p3nbizdglzfbkskhai082fv"))))
    (build-system python-build-system)
    (arguments
     '(;; FIXME: Two tests error out with:
       ;; AssertionError: b'Error in atexit._run_exitfuncs:\nFileNotF[44 chars]ry\n' != b''
       ;; #:phases
       ;; (modify-phases %standard-phases
       ;;   (replace 'check
       ;;     (lambda _
       ;;       ;; 'setup.py test' hits an AssertionError on BSD-specific
       ;;       ;; "tornado/platform/kqueue.py". This is the supported method:
       ;;       (invoke- "python" "-m" "tornado.test")
       ;;       #t)))
       #:tests? #f))
    (native-inputs
     `(("python-certifi" ,python-certifi)))
    (propagated-inputs
     `(("python-backports-abc" ,python-backports-abc)))
    (home-page "http://www.tornadoweb.org/")
    (synopsis "Python web framework and asynchronous networking library")
    (description
     "Tornado is a Python web framework and asynchronous networking library,
originally developed at FriendFeed.  By using non-blocking network I/O,
Tornado can scale to tens of thousands of open connections, making it ideal
for long polling, WebSockets, and other applications that require a long-lived
connection to each user.")
    (license license:asl2.0)
    (properties `((python2-variant . ,(delay python2-tornado))))))

(define-public python2-tornado
  (let ((tornado (package-with-python2 (strip-python2-variant python-tornado))))
    (package (inherit tornado)
      (propagated-inputs
       `(("python2-backport-ssl-match-hostname"
          ,python2-backport-ssl-match-hostname)
         ("python2-singledispatch" ,python2-singledispatch)
          ,@(package-propagated-inputs tornado))))))

(define-public python-tornado-http-auth
  (package
    (name "python-tornado-http-auth")
    (version "1.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "tornado-http-auth" version))
       (sha256
        (base32
         "0znrgqd7k2s4ia474xizi6h3061zj4sn5n6cq76bkwl3wwshifn5"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-tornado" ,python-tornado)))
    (home-page
     "https://github.com/gvalkov/tornado-http-auth")
    (synopsis
     "Digest and basic authentication module for Tornado")
    (description
     "Provides support for adding authentication to services using the Tornado
web framework, either via the basic or digest authentication schemes.")
    (license license:asl2.0)))

(define-public python-terminado
  (package
    (name "python-terminado")
    (version "0.6")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "terminado" version))
       (sha256
        (base32
         "09h1kwi86g5mrk14s4pgbhshd602zry29lnpxamcqz864kva22rc"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-tornado" ,python-tornado)
       ("python-ptyprocess" ,python-ptyprocess)))
    (native-inputs
     `(("python-nose" ,python-nose)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'check
                  (lambda _
                    (invoke "nosetests")
                    #t)))))
    (home-page "https://github.com/takluyver/terminado")
    (synopsis "Terminals served to term.js using Tornado websockets")
    (description "This package provides a Tornado websocket backend for the
term.js Javascript terminal emulator library.")
    (license license:bsd-2)
    (properties `((python2-variant . ,(delay python2-terminado))))))

(define-public python2-terminado
  (let ((terminado (package-with-python2 (strip-python2-variant python-terminado))))
    (package (inherit terminado)
      (propagated-inputs
       `(("python2-backport-ssl-match-hostname"
          ,python2-backport-ssl-match-hostname)
          ,@(package-propagated-inputs terminado))))))

(define-public python-wsgi-intercept
  (package
    (name "python-wsgi-intercept")
    (version "1.2.2")
    (source (origin
             (method url-fetch)
             (uri (string-append
                    "https://pypi.python.org/packages/"
                    "38/76/ebcbc24d0cb77db34520a3ca6ed1bd43ace17d182bbd8dd7d976f1c176fb/"
                    "wsgi_intercept-" version ".tar.gz"))
             (sha256
              (base32
               "0kjj2v2dvmnpdd5h5gk9rzz0f54rhjb0yiz3zg65bmp65slfw65d"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-six" ,python-six)))
    (native-inputs
     `(("python-pytest" ,python-pytest)
       ("python-httplib2" ,python-httplib2)
       ("python-requests" ,python-requests)
       ("python-urllib3" ,python-urllib3)))
    (synopsis "Puts a WSGI application in place of a real URI for testing")
    (description "Wsgi_intercept installs a WSGI application in place of a real
URI for testing.  Testing a WSGI application normally involves starting a
server at a local host and port, then pointing your test code to that address.
Instead, this library lets you intercept calls to any specific host/port
combination and redirect them into a WSGI application importable by your test
program.  Thus, you can avoid spawning multiple processes or threads to test
your Web app.")
    (home-page "https://github.com/cdent/wsgi-intercept")
    (license license:expat)))

(define-public python-webob
  (package
    (name "python-webob")
    (version "1.5.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "WebOb" version))
       (sha256
        (base32
         "02bhhzijfhv8hmi1i54d4b0v43liwhnywhflvxsv4x3zax9s3afq"))))
    (build-system python-build-system)
    (native-inputs
      `(("python-nose" ,python-nose)))
    (home-page "https://webob.org/")
    (synopsis "WSGI request and response object")
    (description
      "WebOb provides wrappers around the WSGI request environment, and an
object to help create WSGI responses.")
    (license license:expat)))

(define-public python2-webob
  (package-with-python2 python-webob))

(define-public python-zope-event
  (package
    (name "python-zope-event")
    (version "4.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pypi.python.org/packages/source/z"
                           "/zope.event/zope.event-" version ".tar.gz"))
       (sha256
        (base32
         "11p75zpfz3ffhz21nzx9wb23xs993ck5s6hkjcvhswwizni5jynw"))))
    (build-system python-build-system)
    (home-page "https://pypi.python.org/pypi/zope.event")
    (synopsis "Event publishing system for Python")
    (description "Zope.event provides an event publishing API, intended for
use by applications which are unaware of any subscribers to their events.  It
is a simple event-dispatching system on which more sophisticated event
dispatching systems can be built.")
    (license license:zpl2.1)))

(define-public python2-zope-event
  (package-with-python2 python-zope-event))

(define-public python-zope-interface
  (package
    (name "python-zope-interface")
    (version "4.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pypi.python.org/packages/source/z"
                           "/zope.interface/zope.interface-" version ".tar.gz"))
       (sha256
        (base32
         "0ks8h73b2g4bkad821qbv0wzjppdrwys33i7ka45ik3wxjg1l8if"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-zope-event" ,python-zope-event)))
    (home-page "https://github.com/zopefoundation/zope.interface")
    (synopsis "Python implementation of the \"design by contract\"
methodology")
    (description "Zope.interface provides an implementation of \"object
interfaces\" for Python.  Interfaces are a mechanism for labeling objects as
conforming to a given API or contract.")
    (license license:zpl2.1)))

(define-public python2-zope-interface
  (package-with-python2 python-zope-interface))

(define-public python-zope-exceptions
  (package
    (name "python-zope-exceptions")
    (version "4.0.8")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pypi.python.org/packages/source/z"
                           "/zope.exceptions/zope.exceptions-"
                           version ".tar.gz"))
       (sha256
        (base32
         "0zwxaaa66sqxg5k7zcrvs0fbg9ym1njnxnr28dfmchzhwjvwnfzl"))))
    (build-system python-build-system)
    (arguments
     '(#:tests? #f)) ; circular dependency with zope.testrunner
    (propagated-inputs
     `(("python-zope-interface" ,python-zope-interface)))
    (home-page "http://cheeseshop.python.org/pypi/zope.exceptions")
    (synopsis "Zope exceptions")
    (description "Zope.exceptions provides general-purpose exception types
that have uses outside of the Zope framework.")
    (license license:zpl2.1)))

(define-public python2-zope-exceptions
  (package-with-python2 python-zope-exceptions))

(define-public python-zope-testing
  (package
    (name "python-zope-testing")
    (version "4.6.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "zope.testing" version))
       (sha256
        (base32
         "0iiq54hjhkk2gpvzfjac70vyn4r0kw0ngvicshxbdwrkgf2gjq3g"))
       (modules '((guix build utils)))
       (snippet
        '(begin
           ;; Remove pre-compiled .pyc files backup files from source.
           (for-each delete-file (find-files "." "(\\.pyc|~)$"))
           #t))))
    (build-system python-build-system)
    (home-page "https://pypi.python.org/pypi/zope.testing")
    (synopsis "Zope testing helpers")
    (description "Zope.testing provides a number of testing utilities for HTML
forms, HTTP servers, regular expressions, and more.")
    (license license:zpl2.1)))

(define-public python2-zope-testing
  (package-with-python2 python-zope-testing))

(define-public python-zope-testrunner
  (package
    (name "python-zope-testrunner")
    (version "4.4.9")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pypi.python.org/packages/source/z"
                           "/zope.testrunner/zope.testrunner-"
                           version ".zip"))
       (sha256
        (base32
         "1r7iqknhh55y45f64mz5hghgvzx34h1i11k350s0avx6q8gznja1"))))
    (build-system python-build-system)
    (arguments
     '(#:tests? #f)) ; FIXME: Tests can't find zope.interface.
    (native-inputs
     `(("python-six" ,python-six)
       ;("python-zope-interface" ,python-zope-interface)
       ("python-zope-exceptions" ,python-zope-exceptions)
       ("python-zope-testing" ,python-zope-testing)
       ("unzip" ,unzip)))
    (propagated-inputs
     `(("python-zope-interface" ,python-zope-interface)))
    (home-page "https://pypi.python.org/pypi/zope.testrunner")
    (synopsis "Zope testrunner script")
    (description "Zope.testrunner provides a script for running Python
tests.")
    (license license:zpl2.1)))

(define-public python2-zope-testrunner
  (let ((base (package-with-python2 python-zope-testrunner)))
    (package
      (inherit base)
      (native-inputs
       (append (package-native-inputs base)
               `(("python2-subunit" ,python2-subunit)
                 ("python2-mimeparse" ,python2-mimeparse)))))))

(define-public python-zope-i18nmessageid
  (package
    (name "python-zope-i18nmessageid")
    (version "4.0.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://pypi.python.org/packages/source/z"
             "/zope.i18nmessageid/zope.i18nmessageid-"
             version ".tar.gz"))
       (sha256
        (base32
         "1rslyph0klk58dmjjy4j0jxy21k03azksixc3x2xhqbkv97cmzml"))))
    (build-system python-build-system)
    (home-page "https://pypi.python.org/pypi/zope.i18nmessageid")
    (synopsis "Message identifiers for internationalization")
    (description "Zope.i18nmessageid provides facilities for declaring
internationalized messages within program source text.")
    (license license:zpl2.1)))

(define-public python2-zope-i18nmessageid
  (package-with-python2 python-zope-i18nmessageid))

(define-public python-zope-schema
  (package
    (name "python-zope-schema")
    (version "4.4.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pypi.python.org/packages/source/z"
                           "/zope.schema/zope.schema-" version ".tar.gz"))
       (sha256
        (base32
         "1p943jdxb587dh7php4vx04qvn7b2877hr4qs5zyckvp5afhhank"))))
    (build-system python-build-system)
    (arguments
     '(#:tests? #f)) ; FIXME: Tests can't find zope.event.
    (propagated-inputs
     `(("python-zope-event" ,python-zope-event)
       ("python-zope-exceptions" ,python-zope-exceptions)
       ("python-zope-interface" ,python-zope-interface)))
    (native-inputs
     `(("python-zope-testing" ,python-zope-testing)
       ("python-coverage" ,python-coverage)
       ("python-nose" ,python-nose)))
    (home-page "https://pypi.python.org/pypi/zope.schema")
    (synopsis "Zope data schemas")
    (description "Zope.scheme provides extensions to zope.interface for
defining data schemas.")
    (license license:zpl2.1)))

(define-public python2-zope-schema
  (package-with-python2 python-zope-schema))

(define-public python-zope-configuration
  (package
    (name "python-zope-configuration")
    (version "4.0.3")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://pypi.python.org/packages/source/z"
                                  "/zope.configuration/zope.configuration-"
                                  version ".tar.gz"))
              (sha256
               (base32
                "1x9dfqypgympnlm25p9m43xh4qv3p7d75vksv9pzqibrb4cggw5n"))))
    (build-system python-build-system)
    (arguments
     '(#:tests? #f)) ; FIXME: Tests can't find zope.interface.
    (propagated-inputs
     `(("python-zope-i18nmessageid" ,python-zope-i18nmessageid)
       ("python-zope-schema" ,python-zope-schema)))
    (home-page "https://pypi.python.org/pypi/zope.configuration")
    (synopsis "Zope Configuration Markup Language")
    (description "Zope.configuration implements ZCML, the Zope Configuration
Markup Language.")
    (license license:zpl2.1)))

(define-public python2-zope-configuration
  (package-with-python2 python-zope-configuration))

(define-public python-zope-proxy
  (package
    (name "python-zope-proxy")
    (version "4.1.6")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pypi.python.org/packages/source/z"
                           "/zope.proxy/zope.proxy-" version ".tar.gz"))
       (sha256
        (base32
         "0pqwwmvm1prhwv1ziv9lp8iirz7xkwb6n2kyj36p2h0ppyyhjnm4"))))
    (build-system python-build-system)
    (arguments
     '(#:tests? #f)) ; FIXME: Tests can't find zope.interface.
    (propagated-inputs
     `(("python-zope-interface" ,python-zope-interface)))
    (home-page "https://pypi.python.org/pypi/zope.proxy")
    (synopsis "Generic, transparent proxies")
    (description "Zope.proxy provides generic, transparent proxies for Python.
Proxies are special objects which serve as mostly-transparent wrappers around
another object, intervening in the apparent behavior of the wrapped object
only when necessary to apply the policy (e.g., access checking, location
brokering, etc.) for which the proxy is responsible.")
    (license license:zpl2.1)))

(define-public python2-zope-proxy
  (package-with-python2 python-zope-proxy))

(define-public python-zope-location
  (package
    (name "python-zope-location")
    (version "4.0.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pypi.python.org/packages/source/z"
                           "/zope.location/zope.location-" version ".tar.gz"))
       (sha256
        (base32
         "1nj9da4ksiyv3h8n2vpzwd0pb03mdsh7zy87hfpx72b6p2zcwg74"))))
    (build-system python-build-system)
    (arguments
     '(#:tests? #f)) ; FIXME: Tests can't find zope.interface.
    (propagated-inputs
     `(("python-zope-proxy" ,python-zope-proxy)
       ("python-zope-schema" ,python-zope-schema)))
    (home-page "https://pypi.python.org/pypi/zope.location/")
    (synopsis "Zope location library")
    (description "Zope.location implements the concept of \"locations\" in
Zope3, which are are special objects that have a structural location.")
    (license license:zpl2.1)))

(define-public python2-zope-location
  (package-with-python2 python-zope-location))

(define-public python-zope-security
  (package
    (name "python-zope-security")
    (version "4.0.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://pypi.python.org/packages/source/z"
                           "/zope.security/zope.security-" version ".tar.gz"))
       (sha256
        (base32
         "14zmf684amc0x32kq05yxnhfqd1cmyhafkw05gn81rn90zjv6ssy"))))
    (build-system python-build-system)
    (arguments
     '(#:tests? #f)) ; FIXME: Tests can't find zope.testrunner.
    (propagated-inputs
     `(("python-zope-i18nmessageid" ,python-zope-i18nmessageid)
       ("python-zope-proxy" ,python-zope-proxy)
       ("python-zope-schema" ,python-zope-schema)))
    (native-inputs
     `(("python-six" ,python-six)
       ("python-zope-component" ,python-zope-component)
       ("python-zope-configuration" ,python-zope-configuration)
       ("python-zope-location" ,python-zope-location)
       ("python-zope-testrunner" ,python-zope-testrunner)
       ("python-zope-testing" ,python-zope-testing)))
    (home-page "https://pypi.python.org/pypi/zope.security")
    (synopsis "Zope security framework")
    (description "Zope.security provides a generic mechanism to implement
security policies on Python objects.")
    (license license:zpl2.1)))

(define-public python2-zope-security
  (let ((zope-security (package-with-python2 python-zope-security)))
    (package (inherit zope-security)
      (propagated-inputs
       `(("python2-zope-testrunner" ,python2-zope-testrunner)
         ,@(alist-delete
            "python-zope-testrunner"
            (package-propagated-inputs zope-security)))))))

(define-public python-zope-component
  (package
    (name "python-zope-component")
    (version "4.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "zope.component" version))
       (sha256
        (base32
         "1hlvzwj1kcfz1qms1dzhwsshpsf38z9clmyksb1gh41n8k3kchdv"))))
    (build-system python-build-system)
    (arguments
     ;; Skip tests due to circular dependency with python-zope-security.
     '(#:tests? #f))
    (native-inputs
     `(("python-zope-testing" ,python-zope-testing)))
    (propagated-inputs
     `(("python-zope-event" ,python-zope-event)
       ("python-zope-interface" ,python-zope-interface)
       ("python-zope-i18nmessageid" ,python-zope-i18nmessageid)
       ("python-zope-configuration" ,python-zope-configuration)))
    (home-page "https://github.com/zopefoundation/zope.component")
    (synopsis "Zope Component Architecture")
    (description "Zope.component represents the core of the Zope Component
Architecture.  Together with the zope.interface package, it provides
facilities for defining, registering and looking up components.")
    (license license:zpl2.1)))

(define-public python2-zope-component
  (package-with-python2 python-zope-component))

(define-public python-ndg-httpsclient
  (package
    (name "python-ndg-httpsclient")
    (version "0.5.1")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "ndg_httpsclient" version))
              (sha256
                (base32
                  "0412b7i1s4vj7lz9r72nmb28h9syd4q2x89bdirkkc3a6z8awbyp"))))
    (build-system python-build-system)
    (arguments
     '(;; The tests appear to require networking.
       #:tests? #f))
    (propagated-inputs
     `(("python-pyopenssl" ,python-pyopenssl)))
    (synopsis "HTTPS support for Python's httplib and urllib2")
    (description "This is a HTTPS client implementation for httplib and urllib2
based on PyOpenSSL.  PyOpenSSL provides a more fully-featured SSL implementation
over the default provided with Python and, importantly, enables full
verification of the SSL peer.")
    (home-page "https://github.com/cedadev/ndg_httpsclient/")
    (license license:bsd-3)))

;; python2-openssl requires special care, so package-with-python2 is
;; insufficient.
(define-public python2-ndg-httpsclient
  (package (inherit python-ndg-httpsclient)
    (name "python2-ndg-httpsclient")
    (arguments
     (substitute-keyword-arguments (package-arguments python-ndg-httpsclient)
       ((#:python _) python-2)))
    (propagated-inputs
     `(("python2-pyopenssl" ,python2-pyopenssl)))))

(define-public python-websocket-client
  (package
    (name "python-websocket-client")
    (version "0.37.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "websocket_client" version))
       (sha256
        (base32
         "0h9glp1jll3z76ly3kg08aqgxqk0a68p4zi9yn50353bh5nj92v7"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-six" ,python-six)))
    (home-page "https://github.com/liris/websocket-client")
    (synopsis "WebSocket client for Python")
    (description "The Websocket-client module provides the low level APIs for
WebSocket usage in Python programs.")
    (license license:lgpl2.1+)))

(define-public python2-websocket-client
  (package-with-python2 python-websocket-client))

(define-public python-requests
  (package
    (name "python-requests")
    (version "2.13.0")
    (source (origin
             (method url-fetch)
             (uri (pypi-uri "requests" version))
             (sha256
              (base32
               "1s0wg4any4dsv5l3hqjxqk2zgb7pdbqhy9rhc8kh3aigfq4ws8jp"))))
    ;; TODO: unbundle urllib3 and chardet.
    (build-system python-build-system)
    (arguments
     ;; FIXME: Some tests require network access.
     '(#:tests? #f))
    (home-page "http://python-requests.org/")
    (synopsis "Python HTTP library")
    (description
     "Requests is a Python HTTP client library.  It aims to be easier to use
than Python’s urllib2 library.")
    (license license:asl2.0)))

;; Some software requires an older version of Requests, notably Docker
;; Compose.
(define-public python-requests-2.7
  (package (inherit python-requests)
    (version "2.7.0")
    (source (origin
             (method url-fetch)
             (uri (pypi-uri "requests" version))
             (sha256
              (base32
               "0gdr9dxm24amxpbyqpbh3lbwxc2i42hnqv50sigx568qssv3v2ir"))))))

(define-public python2-requests
  (package-with-python2 python-requests))

(define-public python-requests-mock
  (package
    (name "python-requests-mock")
    (version "1.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "requests-mock" version))
       (sha256
        (base32
         "0jr997dvk6zbmhvbpcv3rajrgag69mcsm1ai3w3rgk2jdh6rg1mx"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-requests" ,python-requests)
       ("python-six" ,python-six)))
    (native-inputs
     `(("python-pbr" ,python-pbr)
       ("python-discover" ,python-discover)
       ("python-docutils" ,python-docutils)
       ("python-fixtures" ,python-fixtures)
       ("python-mock" ,python-mock)
       ("python-sphinx" ,python-sphinx)
       ("python-testrepository" ,python-testrepository)
       ("python-testtools" ,python-testtools)))
    (home-page "https://requests-mock.readthedocs.org/")
    (synopsis "Mock out responses from the requests package")
    (description
      "This module provides a building block to stub out the HTTP requests
portions of your testing code.")
    (properties `((python2-variant . ,(delay python2-requests-mock))))
    (license license:asl2.0)))

(define-public python2-requests-mock
  (package (inherit (package-with-python2
                     (strip-python2-variant python-requests-mock)))
           (arguments
            `(#:python ,python-2
              ;; FIXME: 'subunit.run discover: error: no such option: --list'
              #:tests? #f))))

(define-public python-requests-toolbelt
  (package
    (name "python-requests-toolbelt")
    (version "0.8.0")
    (source (origin
             (method url-fetch)
             (uri (pypi-uri "requests-toolbelt" version))
             (sha256
              (base32
               "1dc7l42i4080r8i4m9fj51jx367lqkai170vrv7wd93gdj9k39gn"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-betamax" ,python-betamax)
       ("python-mock" ,python-mock)
       ("python-pytest" ,python-pytest)))
    (propagated-inputs
     `(("python-requests" ,python-requests)))
    (synopsis "Extensions to python-requests")
    (description "This is a toolbelt of useful classes and functions to be used
with python-requests.")
    (home-page "https://github.com/sigmavirus24/requests-toolbelt")
    (license license:asl2.0)))

(define-public python2-requests-toolbelt
  (package-with-python2 python-requests-toolbelt))

(define-public python-oauthlib
  (package
    (name "python-oauthlib")
    (version "1.0.3")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "oauthlib" version))
              (sha256
               (base32
                "1bfrj70vdjxjw74khbyh6f0dksv7p5rh2346jnlrffyacd3gwjzg"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-nose" ,python-nose)
       ("python-mock" ,python-mock)
       ("python-cryptography" ,python-cryptography)
       ("python-pyjwt" ,python-pyjwt)
       ("python-blinker" ,python-blinker)))
    (home-page "https://github.com/idan/oauthlib")
    (synopsis "OAuth implementation for Python")
    (description
     "Oauthlib is a generic, spec-compliant, thorough implementation of the
OAuth request-signing logic.")
    (license license:bsd-3)
    (properties `((python2-variant . ,(delay python2-oauthlib))))))

(define-public python2-oauthlib
  (let ((base (package-with-python2 (strip-python2-variant python-oauthlib))))
    (package
      (inherit base)
      (native-inputs `(("python2-unittest2" ,python2-unittest2)
                       ,@(package-native-inputs base))))))

(define-public python-rauth
  (package
    (name "python-rauth")
    (version "0.7.3")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "rauth" version))
        (sha256
         (base32
          "02kv8w8l98ky223avyq7vw7x1f2ya9chrm59r77ylq45qb0xnk2j"))))
    (build-system python-build-system)
    (arguments
     `(#:test-target "check"))
    (propagated-inputs
     `(("python-requests" ,python-requests)))
    (home-page "https://github.com/litl/rauth")
    (synopsis "Python library for OAuth 1.0/a, 2.0, and Ofly")
    (description
     "Rauth is a Python library for OAuth 1.0/a, 2.0, and Ofly.  It also
provides service wrappers for convenient connection initialization and
authenticated session objects providing things like keep-alive.")
    (license license:expat)
    (properties `((python2-variant . ,(delay python2-rauth))))))

(define-public python2-rauth
  (let ((base (package-with-python2 (strip-python2-variant python-rauth))))
    (package
      (inherit base)
      (native-inputs `(("python2-unittest2" ,python2-unittest2)
                       ,@(package-native-inputs base))))))

(define-public python-urllib3
  (package
    (name "python-urllib3")
    (version "1.18.1")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "urllib3" version))
        (sha256
         (base32
          "1wb8aqnq53vzh2amrv8kc66f3h6fx217y0q62y6n30a64p2yqmam"))))
    (build-system python-build-system)
    (arguments `(#:tests? #f))
    (native-inputs
     `(;; some packages for tests
       ("python-nose" ,python-nose)
       ("python-mock" ,python-mock)
       ("python-tornado" ,python-tornado)))
    (propagated-inputs
     `(;; These 5 inputs are used to build urrlib3[secure]
       ("python-certifi" ,python-certifi)
       ("python-cryptography" ,python-cryptography) ;
       ("python-idna" ,python-idna)
       ("python-ipaddress" ,python-ipaddress)
       ("python-pyopenssl" ,python-pyopenssl)))
    (home-page "https://urllib3.readthedocs.org/")
    (synopsis "HTTP library with thread-safe connection pooling")
    (description
     "Urllib3 supports features left out of urllib and urllib2 libraries.  It
can reuse the same socket connection for multiple requests, it can POST files,
supports url redirection and retries, and also gzip and deflate decoding.")
    (license license:expat)))

(define-public python2-urllib3
  (package-with-python2 python-urllib3))

(define-public awscli
  (package
   (name "awscli")
   (version "1.14.41")
   (source
    (origin
     (method url-fetch)
     (uri (pypi-uri name version))
     (sha256
      (base32
       "0sispclx263lybbk19zp1n9yhg8xxx4jddypzgi24vpjaqnsbwlc"))))
   (build-system python-build-system)
   (propagated-inputs
    `(("python-colorama" ,python-colorama)
      ("python-botocore" ,python-botocore)
      ("python-s3transfer" ,python-s3transfer)
      ("python-docutils" ,python-docutils)
      ("python-pyyaml" ,python-pyyaml)
      ("python-rsa" ,python-rsa)))
   (arguments
    ;; FIXME: The 'pypi' release does not contain tests.
    '(#:tests? #f))
   (home-page "https://aws.amazon.com/cli/")
   (synopsis "Command line client for AWS")
   (description "AWS CLI provides a unified command line interface to the
Amazon Web Services (AWS) API.")
   (license license:asl2.0)))

(define-public python-wsgiproxy2
  (package
    (name "python-wsgiproxy2")
    (version "0.4.4")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "WSGIProxy2" version ".tar.gz"))
       (sha256
        (base32
         "16532rjc94h3w74x52jfckf3yzsp8h6z34522jk4xgjy82hpnd7r"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-webtest" ,python-webtest)))
    (propagated-inputs
     `(("python-requests" ,python-requests)
       ("python-six" ,python-six)
       ("python-urllib3" ,python-urllib3)
       ("python-webob" ,python-webob)))
    (home-page "https://github.com/gawel/WSGIProxy2/")
    (synopsis "WSGI Proxy with various http client backends")
    (description "WSGI turns HTTP requests into WSGI function calls.
WSGIProxy turns WSGI function calls into HTTP requests.
It also includes code to sign requests and pass private data,
and to spawn subprocesses to handle requests.")
    (license license:expat)))

(define-public python2-wsgiproxy2
 (package-with-python2 python-wsgiproxy2))

(define-public python-pastedeploy
  (package
    (name "python-pastedeploy")
    (version "1.5.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "PasteDeploy" version))
       (sha256
        (base32
         "1jz3m4hq8v6hyhfjz9425nd3nvn52cvbfipdcd72krjmla4qz1fm"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-nose" ,python-nose)))
    (home-page "http://pythonpaste.org/deploy/")
    (synopsis
     "Load, configure, and compose WSGI applications and servers")
    (description
     "This tool provides code to load WSGI applications and servers from URIs;
these URIs can refer to Python Eggs for INI-style configuration files.  Paste
Script provides commands to serve applications based on this configuration
file.")
    (license license:expat)))

(define-public python2-pastedeploy
  (package-with-python2 python-pastedeploy))

(define-public python-webtest
  (package
    (name "python-webtest")
    (version "2.0.30")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "WebTest" version))
       (sha256
        (base32
         "1mb7m4ndklv84mh0pdkhv73yrflcnra61yczj5g3bvwbqlygfsaw"))))
    (build-system python-build-system)
    (arguments
     `(;; Unfortunately we have to disable tests!
       ;; This release of WebTest is pinned to python-nose < 1.3,
       ;; but older versions of python-nose are plagued with the following
       ;; bug(s), which rears its ugly head during test execution:
       ;;   https://github.com/nose-devs/nose/issues/759
       ;;   https://github.com/nose-devs/nose/pull/811
       #:tests? #f))
    ;; Commented out code is no good, but in this case, once tests
    ;; are ready to be enabled again, we should put the following
    ;; in place:
    ;;  (native-inputs
    ;;   `(("python-nose" ,python-nose) ; technially < 1.3,
    ;;                                  ; but see above comment
    ;;     ("python-coverage" ,python-coverage)
    ;;     ("python-mock" ,python-mock)
    ;;     ("python-pastedeploy" ,python-pastedeploy)
    ;;     ("python-wsgiproxy2" ,python-wsgiproxy2)
    ;;     ("python-pyquery" ,python-pyquery)))
    (propagated-inputs
     `(("python-waitress" ,python-waitress)
       ("python-webob" ,python-webob)
       ("python-six" ,python-six)
       ("python-beautifulsoup4" ,python-beautifulsoup4)))
    (home-page "http://webtest.pythonpaste.org/")
    (synopsis "Helper to test WSGI applications")
    (description "Webtest allows you to test your Python web applications
without starting an HTTP server.  It supports anything that supports the
minimum of WSGI.")
    (license license:expat)))

(define-public python2-webtest
  (package-with-python2 python-webtest))

(define-public python-flask
  (package
    (name "python-flask")
    (version "0.11.1")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "Flask" version))
              (sha256
               (base32
                "03kbfll4sj3v5z7r31c7bhfpi11r1np076d4p1k2kg4yzcmkywdl"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-itsdangerous" ,python-itsdangerous)
       ("python-jinja2" ,python-jinja2)
       ("python-click" ,python-click)
       ("python-werkzeug" ,python-werkzeug)))
    (home-page "https://github.com/mitsuhiko/flask/")
    (synopsis "Microframework based on Werkzeug, Jinja2 and good intentions")
    (description "Flask is a micro web framework based on the Werkzeug toolkit
and Jinja2 template engine.  It is called a micro framework because it does not
presume or force a developer to use a particular tool or library.")
    (license license:bsd-3)))

(define-public python2-flask
  (package-with-python2 python-flask))

(define-public python-flask-wtf
  (package
    (name "python-flask-wtf")
    (version "0.13.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "Flask-WTF" version))
       (sha256
        (base32
         "04l5743j2dici46038sqlzvf0xzpg8rf7s9ld2x24xv7f4idg990"))))
    (build-system python-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-before 'check 'drop-failing-test
           (lambda _
             ;; FIXME: This file tries resolving an external server, which
             ;; fails. Try to patch out the offending section instead of
             ;; deleting the whole thing.
             (delete-file "tests/test_recaptcha.py")
             #t)))))
    (propagated-inputs
     `(("python-flask-babel" ,python-flask-babel)
       ("python-babel" ,python-babel)
       ("python-wtforms" ,python-wtforms)))
    (native-inputs
     `(("python-nose" ,python-nose)))
    (home-page "https://github.com/lepture/flask-wtf")
    (synopsis "Simple integration of Flask and WTForms")
    (description "Flask-WTF integrates Flask and WTForms, including CSRF, file
upload, and reCAPTCHA.")
    (license license:bsd-3)))

(define-public python2-flask-wtf
  (package-with-python2 python-flask-wtf))

(define-public python-flask-multistatic
  (package
    (name "python-flask-multistatic")
    (version "1.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "flask-multistatic" version))
       (sha256
        (base32
         "0p4v50rwv64wcd0zlq7rzl4waprwr4hj19s3cgf1isywa7jcisgm"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-flask" ,python-flask)))
    (home-page "https://pagure.io/flask-multistatic")
    (synopsis "Flask plugin to allow overriding static files")
    (description "@code{flask-multistatic} is a flask plugin that adds support
for overriding static files.")
    (license license:gpl3+)))

(define-public python2-flask-multistatic
  (package-with-python2 python-flask-multistatic))

(define-public python-cookies
  (package
    (name "python-cookies")
    (version "2.2.1")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "cookies" version))
              (sha256
               (base32
                "13pfndz8vbk4p2a44cfbjsypjarkrall71pgc97glk5fiiw9idnn"))))
    (build-system python-build-system)
    (arguments
     `(;; test are broken: https://gitlab.com/sashahart/cookies/issues/3
       #:tests? #f))
    (native-inputs
     `(("python-pytest" ,python2-pytest)))
    (synopsis "HTTP cookie parser and renderer")
    (description "A RFC 6265-compliant HTTP cookie parser and renderer in
Python.")
    (home-page "https://gitlab.com/sashahart/cookies")
    (license license:expat)))

(define-public python2-cookies
  (package-with-python2 python-cookies))

(define-public python-responses
  (package
    (name "python-responses")
    (version "0.5.1")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "responses" version))
              (sha256
               (base32
                "1spcfxixyk9k7pk82jm6zqkwk031s95lh8q0mz7539jrb7269bcc"))))
    (build-system python-build-system)
    (arguments
     `(;; Test suite is not distributed:
       ;; https://github.com/getsentry/responses/issues/38
       #:tests? #f))
    (native-inputs
     `(("python-mock" ,python-mock)))
    (propagated-inputs
     `(("python-requests" ,python-requests)
       ("python-cookies" ,python-cookies)
       ("python-six" ,python-six)))
    (home-page "https://github.com/getsentry/responses")
    (synopsis "Utility for mocking out the `requests` Python library")
    (description "A utility library for mocking out the `requests` Python
library.")
    (license license:asl2.0)))

(define-public python2-responses
  (package-with-python2 python-responses))

(define-public python-grequests
  (package
    (name "python-grequests")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "grequests" version))
       (sha256
        (base32
         "1j9icncllbkv7x5719b20mx670c6q1jrdx1sakskkarvx3pc8h8g"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-gevent" ,python-gevent)
       ("python-requests" ,python-requests)))
    (native-inputs
     `(("python-nose" ,python-nose)))
    (home-page "https://github.com/kennethreitz/grequests")
    (synopsis "Python library for asynchronous HTTP requests")
    (description "GRequests is a Python library that allows you to use
@code{Requests} with @code{Gevent} to make asynchronous HTTP Requests easily")
    (license license:bsd-2)))

(define-public python-geventhttpclient
  (package
    (name "python-geventhttpclient")
    (version "1.3.1")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "geventhttpclient" version))
              (sha256
               (base32
                "07d0q3wzmml75227r6y6mrl5a0zpf4v9gj0ni5rhbyzmaj4az1xx"))
              (modules '((guix build utils)))
              (snippet
               '(begin
                  ;; Delete pre-compiled files.
                  (for-each delete-file (find-files "src/geventhttpclient"
                                                    ".*\\.pyc"))
                  #t))))
    (build-system python-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'delete-network-tests
           (lambda _
             (delete-file "src/geventhttpclient/tests/test_client.py")
             #t))
         (delete 'check)
         (add-after 'install 'check
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (add-installed-pythonpath inputs outputs)
             (invoke "py.test" "src/geventhttpclient/tests" "-v")
             #t)))))
    (native-inputs
     `(("python-pytest" ,python-pytest)))
    (propagated-inputs
     `(("python-certifi" ,python-certifi)
       ("python-gevent" ,python-gevent)
       ("python-six" ,python-six)))
    (home-page "https://github.com/gwik/geventhttpclient")
    (synopsis "HTTP client library for gevent")
    (description "@code{python-geventhttpclient} is a high performance,
concurrent HTTP client library for python using @code{gevent}.")
    (license license:expat)))

(define-public python2-geventhttpclient
  (package-with-python2 python-geventhttpclient))

(define-public python-requests-oauthlib
  (package
    (name "python-requests-oauthlib")
    (version "0.6.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "requests-oauthlib" version))
       (sha256
        (base32
         "0ykff67sjcl227c23g0rxzfx34rr5bf21kwv0z3zmgk0lfmch7hn"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         ;; removes tests that require network access
         (add-before 'check 'pre-check
           (lambda _
             (delete-file "tests/test_core.py")
             #t)))))
    (native-inputs
     `(("python-requests-mock" ,python-requests-mock)
       ("python-mock" ,python-mock)))
    (propagated-inputs
     `(("python-oauthlib" ,python-oauthlib)
       ("python-requests" ,python-requests)))
    (home-page
     "https://github.com/requests/requests-oauthlib")
    (synopsis
     "OAuthlib authentication support for Requests")
    (description
     "Requests-OAuthlib uses the Python Requests and OAuthlib libraries to
provide an easy-to-use Python interface for building OAuth1 and OAuth2 clients.")
    (license license:isc)))

(define-public python2-requests-oauthlib
  (package-with-python2 python-requests-oauthlib))

(define-public python-url
  (package
    (name "python-url")
    (version "0.2.0")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "url" version))
              (sha256
               (base32
                "0v879yadcz9qxfl41ak6wkga1kimp9cflla9ddz03hjjvgkqy5ki"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-publicsuffix" ,python-publicsuffix)))
    (native-inputs
     `(("python-coverage" ,python-coverage)
       ("python-nose" ,python-nose)))
    (arguments
     `(#:tests? #f)) ; FIXME: tests fail with "ImportError: No module named 'tests'"
    (home-page "https://github.com/seomoz/url-py")
    (synopsis "URL Parsing")
    (description "Library for parsing urls.")
    (license license:expat)
    (properties `((python2-variant . ,(delay python2-url))))))

(define-public python2-url
  (let ((base (package-with-python2 (strip-python2-variant python-url))))
    (package (inherit base)
      (propagated-inputs
       `(("python2-publicsuffix" ,python2-publicsuffix))))))

(define-public python-cachecontrol
  (package
    (name "python-cachecontrol")
    (version "0.11.6")
    (source
     (origin
       (method url-fetch)
       ;; Pypi does not have tests.
       (uri (string-append
             "https://github.com/ionrock/cachecontrol/archive/v"
             version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "0yj60d0f69a2l8p7y86k4zhzzm6rnxpq74sfl240pry9l0lfw2vw"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda _
             ;; Drop test that requires internet access.
             (delete-file "tests/test_regressions.py")
             (setenv "PYTHONPATH"
                     (string-append (getcwd) "/build/lib:"
                                    (getenv "PYTHONPATH")))
             (invoke "py.test" "-vv")
             #t)))))
    (native-inputs
     `(("python-pytest" ,python-pytest)
       ("python-redis" ,python-redis)
       ("python-webtest" ,python-webtest)
       ("python-mock" ,python-mock)))
    (propagated-inputs
     `(("python-requests" ,python-requests)
       ("python-lockfile" ,python-lockfile)))
    (home-page "https://github.com/ionrock/cachecontrol")
    (synopsis "The httplib2 caching algorithms for use with requests")
    (description "CacheControl is a port of the caching algorithms in
@code{httplib2} for use with @code{requests} session objects.")
    (license license:asl2.0)))

(define-public python2-cachecontrol
  (package-with-python2 python-cachecontrol))

(define-public python-betamax
  (package
    (name "python-betamax")
    (version "0.8.1")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "betamax" version))
        (sha256
         (base32
          "1hki1c2vs7adq7zr56wi6i5bhrkia4s2ywpv2c98ibnczz709w2v"))))
    (build-system python-build-system)
    (arguments
     '(;; Many tests fail because they require networking.
       #:tests? #f))
    (propagated-inputs
     `(("python-requests" ,python-requests)))
    (home-page "https://github.com/sigmavirus24/betamax")
    (synopsis "Record HTTP interactions with python-requests")
    (description "Betamax will record your test suite's HTTP interactions and
replay them during future tests.  It is designed to work with python-requests.")
    (license license:expat)))

(define-public python2-betamax
  (package-with-python2 python-betamax))

(define-public python-betamax-matchers
  (package
    (name "python-betamax-matchers")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "betamax-matchers" version))
       (sha256
        (base32
         "07qpwjyq2i2aqhz5iwghnj4pqr2ys5n45v1vmpcfx9r5mhwrsq43"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-betamax" ,python-betamax)
       ("python-requests-toolbelt" ,python-requests-toolbelt)))
    (home-page "https://github.com/sigmavirus24/betamax_matchers")
    (synopsis "VCR imitation for python-requests")
    (description "@code{betamax-matchers} provides a set of Matchers for
Betamax.")
    (license license:asl2.0)))

(define-public python2-betamax-matchers
  (package-with-python2 python-betamax-matchers))

(define-public python-s3transfer
  (package
    (name "python-s3transfer")
    (version "0.1.13")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "s3transfer" version))
              (sha256
               (base32
                "1harvyn1s8v54n1w5h7c0lg4bgjh68aylhg28s8n174q53h1ip4h"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda _
             ;; 7 of the 'integration' tests require network access or login
             ;; credentials.
             (invoke "nosetests" "--exclude=integration")
             #t)))))
    (native-inputs
     `(("python-docutils" ,python-docutils)
       ("python-mock" ,python-mock)
       ("python-nose" ,python-nose)))
    (propagated-inputs
     `(("python-botocore" ,python-botocore)))
    (synopsis "Amazon S3 Transfer Manager")
    (description "S3transfer is a Python library for managing Amazon S3
transfers.")
    (home-page "https://github.com/boto/s3transfer")
    (license license:asl2.0)
    (properties `((python2-variant . ,(delay python2-s3transfer))))))

(define-public python2-s3transfer
  (let ((base (package-with-python2 (strip-python2-variant python-s3transfer))))
    (package
      (inherit base)
      (native-inputs
       `(("python2-futures" ,python2-futures)
         ,@(package-native-inputs base))))))

(define-public python-flask-restful
  (package
    (name "python-flask-restful")
    (version "0.3.5")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "Flask-RESTful" version))
        (sha256
          (base32
            "0hjcmdb56b7z4bkw848lxfkyrpnkwzmqn2dgnlv12mwvjpzsxr6c"))))
    (build-system python-build-system)
    (propagated-inputs
      `(("python-aniso8601" ,python-aniso8601)
        ("python-flask" ,python-flask)
        ("python-pycrypto" ,python-pycrypto)
        ("python-pytz" ,python-pytz)))
    (native-inputs
      `(;; Optional dependency of Flask. Tests need it.
        ("python-blinker" ,python-blinker)
        ("python-mock" ,python-mock) ; For tests
        ("python-nose" ,python-nose) ; For tests
        ("python-sphinx" ,python-sphinx)))
    (home-page
      "https://www.github.com/flask-restful/flask-restful/")
    (synopsis
      "Flask module for creating REST APIs")
    (description
      "This package contains a Flask module for creating REST APIs.")
    (license license:bsd-3)))

(define-public python-flask-basicauth
  (package
    (name "python-flask-basicauth")
    (version "0.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "Flask-BasicAuth" version))
        (sha256
          (base32
            "1zq1spkjr4sjdnalpp8wl242kdqyk6fhbnhr8hi4r4f0km4bspnz"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-flask" ,python-flask)))
    (home-page
      "https://github.com/jpvanhal/flask-basicauth")
    (synopsis
      "HTTP basic access authentication for Flask")
    (description
      "This package provides HTTP basic access authentication for Flask.")
    (license license:bsd-3)))

(define-public python-flask-sqlalchemy
  (package
    (name "python-flask-sqlalchemy")
    (version "2.1")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "Flask-SQLAlchemy" version))
        (sha256
          (base32
            "1i9ps5d5snih9xlqhrvmi3qfiygkmqzxh92n25kj4pf89kj4s965"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-flask" ,python-flask)
       ("python-sqlalchemy" ,python-sqlalchemy)))
    (home-page
      "https://github.com/mitsuhiko/flask-sqlalchemy")
    (synopsis
      "Module adding SQLAlchemy support to your Flask application")
    (description
      "This package adds SQLAlchemy support to your Flask application.")
    (license license:bsd-3)))

(define-public python-flask-restplus
  (package
    (name "python-flask-restplus")
    (version "0.9.2")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "flask-restplus" version))
        (sha256
          (base32
            "11his6ii5brpkhld0d5bwzjjw4q3vmplpd6fmgzjrvvklsbk0cf4"))))
    (build-system python-build-system)
    (arguments
     '(#:tests? #f)) ; FIXME: 35/882 tests failing.
       ;; #:phases
       ;; (modify-phases %standard-phases
       ;;   (replace 'check
       ;;     (lambda _
       ;;       (invoke "nosetests")
       ;;       #t)))))
    (propagated-inputs
      `(("python-aniso8601" ,python-aniso8601)
        ("python-flask" ,python-flask)
        ("python-jsonschema" ,python-jsonschema)
        ("python-pytz" ,python-pytz)
        ("python-six" ,python-six)))
    (native-inputs
     `(("python-tzlocal" ,python-tzlocal)
       ("python-blinker" ,python-blinker)
       ("python-nose" ,python-nose)
       ("python-rednose" ,python-rednose)))
    (home-page "https://github.com/noirbizarre/flask-restplus")
    (synopsis "Framework for documented API development with Flask")
    (description "This package provides a framework for API development with
the Flask web framework in Python.  It is similar to package
@code{python-flask-restful} but supports the @code{python-swagger}
documentation builder.")
    (license license:expat)))

(define-public python-flask-restful-swagger
  (package
    (name "python-flask-restful-swagger")
    (version "0.19")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "flask-restful-swagger" version))
       (sha256
        (base32
         "16msl8hd5xjmj833bpy264v98cpl5hkw5bgl5gf5vgndxbv3rm6v"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-flask-restful" ,python-flask-restful)))
    (home-page "https://github.com/rantav/flask-restful-swagger")
    (synopsis "Extract Swagger specs from Flask-Restful projects")
    (description "This package lets you extract Swagger API documentation
specs from your Flask-Restful projects.")
    (license license:expat)))

(define-public python2-flask-restful-swagger
  (package-with-python2 python-flask-restful-swagger))

(define-public python-htmlmin
  (package
    (name "python-htmlmin")
    (version "0.1.12")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "htmlmin" version))
       (sha256
        (base32
         "0y51xhabw6x8jk8k93xl8vznshpz3jb6l28075r5sjip613fzhah"))))
    (arguments
     `(#:tests? #f))                    ; no tests
    (build-system python-build-system)
    (home-page "https://htmlmin.readthedocs.org/en/latest/")
    (synopsis "HTML minifier")
    (description "@code{htmlmin} is an HTML minifier that just works.
It comes with safe defaults and easily configurable options.")
    (license license:bsd-3)))

(define-public python2-htmlmin
  (package-with-python2 python-htmlmin))

(define-public python-flask-htmlmin
  (package
    (name "python-flask-htmlmin")
    (version "1.2")
    (source
    (origin
      (method url-fetch)
      (uri (pypi-uri "Flask-HTMLmin" version))
      (sha256
       (base32
        "1n6zlq72kakkw0z2jpq6nh74lfsmxybm4g053pwhc14fbr809348"))))
    (propagated-inputs
     `(("python-flask" ,python-flask)
       ("python-htmlmin" ,python-htmlmin)))
    (build-system python-build-system)
    (home-page "https://github.com/hamidfzm/Flask-HTMLmin")
    (synopsis "HTML response minifier for Flask")
    (description
     "Minify @code{text/html} MIME type responses when using @code{Flask}.")
    (license license:bsd-3)))

(define-public python2-flask-htmlmin
  (package-with-python2 python-flask-htmlmin))

(define-public python-flask-login
  (package
    (name "python-flask-login")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/maxcountryman/flask-login/archive/"
                           version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1pdqp7a2gyb7k06xda004x0fi2w66s6kn2i0ndkqndmg12d83f9w"))))
    (arguments
     ;; Tests fail PEP8 compliance. See:
     ;; https://github.com/maxcountryman/flask-login/issues/340
     `(#:tests? #f))
    (build-system python-build-system)
    (home-page "https://github.com/maxcountryman/flask-login")
    (synopsis "User session management for Flask")
    (description
     "@code{Flask-Login} provides user session management for Flask.  It
handles the common tasks of logging in, logging out, and remembering your
users' sessions over extended periods of time.")
    (license license:expat)))

(define-public python2-flask-login
  (package-with-python2 python-flask-login))

(define-public python-oauth2client
  (package
    (name "python-oauth2client")
    (version "4.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "oauth2client" version))
       (sha256
        (base32
         "1irqqap2zibysf8dba8sklfqikia579srd0phm5n754ni0h59gl0"))))
    (build-system python-build-system)
    (arguments
     `(#:tests? #f))
    (propagated-inputs
     `(("python-httplib2" ,python-httplib2)
       ("python-pyasn1" ,python-pyasn1)
       ("python-pyasn1-modules" ,python-pyasn1-modules)
       ("python-rsa" ,python-rsa)
       ("python-six" ,python-six)))
    (home-page "https://github.com/google/oauth2client/")
    (synopsis "OAuth 2.0 client library")
    (description "@code{python-oauth2client} provides an OAuth 2.0 client
library for Python")
    (license license:asl2.0)))

(define-public python2-oauth2client
  (package-with-python2 python-oauth2client))

(define-public python-flask-oidc
  (package
    (name "python-flask-oidc")
    (version "1.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "flask-oidc" version))
       (sha256
        (base32
         "1ay5j0mf174bix7i67hclr95gv16z81fpx0dijvi0gydvdj3ddy2"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-flask" ,python-flask)
       ("python-itsdangerous" ,python-itsdangerous)
       ("python-oauth2client" ,python-oauth2client)
       ("python-six" ,python-six)))
    (native-inputs
     `(("python-nose" ,python-nose)
       ("python-mock" ,python-mock)))
    (home-page "https://github.com/puiterwijk/flask-oidc")
    (synopsis "OpenID Connect extension for Flask")
    (description "@code{python-flask-oidc} provides an OpenID Connect extension
for Flask.")
    (license license:bsd-2)))

(define-public python-webassets
  (package
    (name "python-webassets")
    (version "0.12.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "webassets" version))
       (sha256
        (base32
         "1nrqkpb7z46h2b77xafxihqv3322cwqv6293ngaky4j3ff4cing7"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-jinja2" ,python-jinja2)
       ("python-mock" ,python-mock)
       ("python-nose" ,python-nose)
       ("python-pytest" ,python-pytest)))
    (home-page "https://github.com/miracle2k/webassets")
    (synopsis "Media asset management")
    (description "Merges, minifies and compresses Javascript and CSS files,
supporting a variety of different filters, including YUI, jsmin, jspacker or
CSS tidy.  Also supports URL rewriting in CSS files.")
    (license license:bsd-2)))

(define-public python-cssmin
  (package
    (name "python-cssmin")
    (version "0.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "cssmin" version))
        (sha256
         (base32
          "1dk723nfm2yf8cp4pj785giqlwv42l0kj8rk40kczvq1hk6g04p0"))))
    (build-system python-build-system)
    (home-page "https://github.com/zacharyvoase/cssmin")
    (synopsis "Python port of the YUI CSS Compressor")
    (description "Python port of the YUI CSS Compressor.")
    (license (list license:expat license:bsd-3))))

(define-public python2-cssmin
  (package-with-python2 python-cssmin))

(define-public python-elasticsearch
  (package
    (name "python-elasticsearch")
    (version "6.1.1")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "elasticsearch" version))
        (sha256
         (base32
          "1kjxl45yvvgfb5fmamx0kfsfg9pzphiqrwbkns3s28r1w7ya74cd"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-mock" ,python-mock)
       ("python-nosexcover" ,python-nosexcover)
       ("python-pyaml" ,python-pyaml)
       ("python-requests" ,python-requests)))
    (propagated-inputs
     `(("urllib3" ,python-urllib3)))
    (arguments
     ;; tests require the test_elasticsearch module but it is not distributed.
     `(#:tests? #f))
    (home-page "https://github.com/elastic/elasticsearch-py")
    (synopsis "Low-level client for Elasticsearch")
    (description "Official low-level client for Elasticsearch.  Its goal is to
provide common ground for all Elasticsearch-related code in Python; because of
this it tries to be opinion-free and very extendable.")
    (license license:expat)))

(define-public python2-elasticsearch
  (package-with-python2 python-elasticsearch))

(define-public python-flask-script
  (package
  (name "python-flask-script")
  (version "2.0.6")
  (source
    (origin
      (method url-fetch)
      (uri (pypi-uri "Flask-Script" version))
      (sha256
        (base32
          "0r8w2v89nj6b9p91p495cga5m72a673l2wc0hp0zqk05j4yrc9b4"))))
  (build-system python-build-system)
  (propagated-inputs
   `(("python-flask" ,python-flask)
     ("python-argcomplete" ,python-argcomplete)
     ("python-werkzeug" ,python-werkzeug)))
  (native-inputs
   `(("python-pytest" ,python-pytest)))
  (home-page
    "https://github.com/smurfix/flask-script")
  (synopsis "Scripting support for Flask")
  (description "The Flask-Script extension provides support for writing
external scripts in Flask.  This includes running a development server,
a customised Python shell, scripts to set up your database, cronjobs,
and other command-line tasks that belong outside the web application
itself.")
  (license license:bsd-3)))

(define-public python2-flask-script
  (package-with-python2 python-flask-script))

(define-public python-flask-migrate
  (package
  (name "python-flask-migrate")
  (version "2.0.3")
  (source
    (origin
      (method url-fetch)
      (uri (pypi-uri "Flask-Migrate" version))
      (sha256
        (base32
          "107x78lkqsnbg92dld3dkagg07jvchp3ib3y0sivc4ipz6n1y7rk"))))
  (build-system python-build-system)
  (propagated-inputs
   `(("python-flask" ,python-flask)
     ("python-alembic" ,python-alembic)
     ("python-sqlalchemy" ,python-sqlalchemy)
     ("python-flask-script" ,python-flask-script)
     ("python-flask-sqlalchemy" ,python-flask-sqlalchemy)))
  (home-page "https://github.com/miguelgrinberg/flask-migrate/")
  (synopsis "SQLAlchemy database migrations for Flask programs using
Alembic")
  (description "This package contains SQLAlchemy database migration tools
for Flask programs that are using @code{python-alembic}.")
  (license license:expat)))

(define-public python2-flask-migrate
  (package-with-python2 python-flask-migrate))

(define-public python-genshi
  (package
    (name "python-genshi")
    (version "0.7.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/edgewall/genshi.git")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "01fx8fnpay5w048ppyjivg2dgfpp5rybn07y3pfsgj2knram3nhl"))))
    (build-system python-build-system)
    (home-page "https://genshi.edgewall.org/")
    (synopsis "Toolkit for generation of output for the web")
    (description "Genshi is a Python library that provides an integrated set
of components for parsing, generating, and processing HTML, XML or other
textual content for output generation on the web.")
    (license license:bsd-3)))

(define-public python2-genshi
  (package-with-python2 python-genshi))

(define-public python-flask-principal
  (package
    (name "python-flask-principal")
    (version "0.4.0")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "Flask-Principal" version))
        (sha256
          (base32
           "0lwlr5smz8vfm5h9a9i7da3q1c24xqc6vm9jdywdpgxfbi5i7mpm"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-blinker" ,python-blinker)))
    (native-inputs
     `(("python-flask" ,python-flask)
       ("python-nose" ,python-nose)))
    (home-page "http://packages.python.org/Flask-Principal/")
    (synopsis "Identity management for Flask")
    (description "@code{flask_principal} is a identity management library for
Flask.  It supports managing both authentication and authorization data in a
thread-local variable.")
    (license license:expat)))

(define-public python2-flask-principal
  (package-with-python2 python-flask-principal))

(define-public python-flask-httpauth
  (package
    (name "python-flask-httpauth")
    (version "3.2.3")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "Flask-HTTPAuth" version))
       (sha256
        (base32
         "13gff5w1mqpzm5nccyg02v3ifb9ifqh5k866cssjhghhg6msfjsz"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-flask" ,python-flask)))
    (home-page "https://github.com/miguelgrinberg/flask-httpauth/")
    (synopsis "Basic and Digest HTTP authentication for Flask routes")
    (description "@code{flask_httpauth} provides Basic and Digest HTTP
authentication for Flask routes.")
    (license license:expat)))

(define-public python2-flask-httpauth
  (package-with-python2 python-flask-httpauth))

(define-public python-uritemplate
  (package
    (name "python-uritemplate")
    (version "3.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "uritemplate" version))
       (sha256
        (base32
         "0781gm9g34wa0asc19dx81ng0nqq07igzv3bbvdqmz13pv7469n0"))))
    (build-system python-build-system)
    (home-page "https://uritemplate.readthedocs.org")
    (synopsis "Library to deal with URI Templates")
    (description "@code{uritemplate} provides Python library to deal with URI
Templates.")
    (license license:bsd-2)))

(define-public python2-uritemplate
  (package-with-python2 python-uritemplate))

(define-public python-publicsuffix
  (package
    (name "python-publicsuffix")
    (version "1.1.0")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "publicsuffix" version))
              (sha256
               (base32
                "1adx520249z2cy7ykwjr1k190mn2888wqn9jf8qm27ly4qymjxxf"))))
    (build-system python-build-system)
    (arguments
     `(#:tests? #f)) ; tests use the internet
    (home-page "https://www.tablix.org/~avian/git/publicsuffix.git")
    (synopsis "Get suffix for a domain name")
    (description "Get a public suffix for a domain name using the Public Suffix
List.")
    (license license:expat)))

(define-public python2-publicsuffix
  (package-with-python2 python-publicsuffix))

(define-public python-publicsuffix2
  (package
    (name "python-publicsuffix2")
    (version "2.20160818")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "publicsuffix2" version ".tar.bz2"))
       (sha256
        (base32
         "1bb55yka9vkn7i6y1kjzxa516kh6v4gsrxa90w5wdz5p5n968r68"))))
    (build-system python-build-system)
    (arguments
     '(#:tests? #f)) ; The test suite requires network access.
    (home-page "https://github.com/pombredanne/python-publicsuffix2")
    (synopsis "Get a public suffix for a domain name using the Public Suffix List")
    (description "Get a public suffix for a domain name using the Public Suffix
List.  Forked from and using the same API as the publicsuffix package.")
    (license (list license:expat license:mpl2.0))))

(define-public python2-publicsuffix2
  (package-with-python2 python-publicsuffix2))

(define-public python-werkzeug
  (package
    (name "python-werkzeug")
    (version "0.11.15")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "Werkzeug" version))
       (sha256
        (base32
         "1h5wycw8yj7q0grqsjnsqflmrlsdagvl2j4dsgdncci6mjc7fpa5"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-pytest" ,python-pytest)))
    (home-page "http://werkzeug.pocoo.org/")
    (synopsis "Utilities for WSGI applications")
    (description "One of the most advanced WSGI utility modules.  It includes a
powerful debugger, full-featured request and response objects, HTTP utilities to
handle entity tags, cache control headers, HTTP dates, cookie handling, file
uploads, a powerful URL routing system and a bunch of community-contributed
addon modules.")
    (license license:x11)))

(define-public python2-werkzeug
  (package-with-python2 python-werkzeug))

(define-public python-bottle
  (package
    (name "python-bottle")
    (version "0.12.13")
    (source
     (origin
      (method url-fetch)
      (uri (pypi-uri "bottle" version))
      (sha256
        (base32
          "0m9k2a7yxvggc4kw8fsvj381vgsvfcdshg5nzy6vwrxiw2p53drr"))))
    (build-system python-build-system)
    (home-page "http://bottlepy.org/")
    (synopsis "WSGI framework for small web-applications.")
    (description "@code{python-bottle} is a WSGI framework for small web-applications.")
    (license license:expat)))

(define-public python2-bottle
  (package-with-python2 python-bottle))

(define-public python-wtforms
  (package
    (name "python-wtforms")
    (version "2.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "WTForms" version ".zip"))
       (sha256
        (base32
         "0vyl26y9cg409cfyj8rhqxazsdnd0jipgjw06civhrd53yyi1pzz"))))
    (build-system python-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'remove-django-test
           ;; Don't fail the tests when the inputs for the optional tests cannot be found.
           (lambda _
             (substitute*
               "tests/runtests.py"
               (("'ext_django.tests', 'ext_sqlalchemy', 'ext_dateutil', 'locale_babel'") "")
               (("sys.stderr.write(\"### Disabled test '%s', dependency not found\n\" % name)") ""))
             #t)))))
    (native-inputs
     `(("unzip" ,unzip)))
    (home-page "http://wtforms.simplecodes.com/")
    (synopsis
     "Form validation and rendering library for Python web development")
    (description
     "WTForms is a flexible forms validation and rendering library
for Python web development.  It is very similar to the web form API
available in Django, but is a standalone package.")
    (license license:bsd-3)))

(define-public python2-wtforms
  (package-with-python2 python-wtforms))

(define-public python-paste
  (package
    (name "python-paste")
    (version "2.0.3")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "Paste" version))
       (sha256
        (base32
         "062jk0nlxf6lb2wwj6zc20rlvrwsnikpkh90y0dn8cjch93s6ii3"))
       (patches (search-patches "python-paste-remove-website-test.patch"
                                "python-paste-remove-timing-test.patch"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-nose" ,python-nose)))
    (propagated-inputs
     `(("python-six" ,python-six)))
    (home-page "http://pythonpaste.org")
    (synopsis
     "Python web development tools, focusing on WSGI")
    (description
     "Paste provides a variety of web development tools and middleware which
can be nested together to build web applications.  Paste's design closely
follows ideas flowing from WSGI (Web Standard Gateway Interface).")
    (license license:expat)))

(define-public python2-paste
  (package-with-python2 python-paste))

(define-public python-pastescript
  (package
    (name "python-pastescript")
    (version "2.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "PasteScript" version))
       (sha256
        (base32
         "1h3nnhn45kf4pbcv669ik4faw04j58k8vbj1hwrc532k0nc28gy0"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-nose" ,python-nose)))
    (propagated-inputs
     `(("python-paste" ,python-paste)
       ("python-pastedeploy" ,python-pastedeploy)))
    (home-page "http://pythonpaste.org/script/")
    (arguments
     '(;; Unfortunately, this requires the latest unittest2,
       ;; but that requires traceback2 which requires linecache2 which requires
       ;; unittest2.  So we're skipping tests for now.
       ;; (Note: Apparently linetest2 only needs unittest2 for its tests,
       ;; so in theory we could get around this situation somehow.)
       #:tests? #f))
    (synopsis
     "Pluggable command line tool for serving web applications and more")
    (description
     "PasteScript is a plugin-friendly command line tool which provides a
variety of features, from launching web applications to bootstrapping project
layouts.")
    (license license:expat)))

(define-public python2-pastescript
  (package-with-python2 python-pastescript))

(define-public python2-urlgrabber
  (package
    (name "python2-urlgrabber")
    (version "3.10.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "urlgrabber" version))
       (sha256
        (base32 "0w1h7hlsq406bxfy2pn4i9bd003bwl0q9b7p03z3g6yl0d21ddq5"))))
    (build-system python-build-system)
    (arguments `(#:python ,python-2)) ; urlgrabber supports python2 only
    (home-page "http://urlgrabber.baseurl.org")
    (synopsis "High-level cross protocol url-grabber")
    (description "@code{urlgrabber} is Python2 library that unifies access to
files available on web, FTP or locally.  It supports HTTP, FTP and file://
protocols, it supports features like HTTP keep-alive, reget, throttling and
more.")
    (license license:lgpl2.1+)))

(define-public python-pycares
  (package
    (name "python-pycares")
    (version "2.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pycares" version))
       (sha256
        (base32
         "0h4fxw5drrhfyslzmfpljk0qnnpbhhb20hnnndzahhbwylyw1x1n"))))
    (build-system python-build-system)
    (arguments
     `(#:tests? #f))                    ;tests require internet access
    (home-page "http://github.com/saghul/pycares")
    (synopsis "Python interface for @code{c-ares}")
    (description "@code{pycares} is a Python module which provides an
interface to @code{c-ares}, a C library that performs DNS requests and
name resolutions asynchronously.")
    (license license:expat)))

(define-public python-yarl
  (package
    (name "python-yarl")
    (version "1.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "yarl" version))
       (sha256
        (base32
         "1s6z13g8vgxfkkqwhn6imnm7pl7ky9arv4jygnn6bcndcbidg7d6"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-pytest" ,python-pytest)
       ("python-pytest-runner" ,python-pytest-runner)))
    (propagated-inputs
     `(("python-idna" ,python-idna)
       ("python-multidict" ,python-multidict)))
    (home-page "https://github.com/aio-libs/yarl/")
    (synopsis "Yet another URL library")
    (description "@code{yarl} module provides handy @code{URL} class
for URL parsing and changing.")
    (license license:asl2.0)))

(define-public python-google-api-client
  (package
    (name "python-google-api-client")
    (version "1.6.7")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "google-api-python-client" version))
       (sha256
        (base32
         "1wpbbbxfpy9mwxdy3kn352cb590ladv574j1aa2l4grjdqw3ln05"))))
    (build-system python-build-system)
    (arguments
     '(#:tests? #f)) ; tests require internet access
    (native-inputs
     `(("python-httplib2" ,python-httplib2)
       ("python-six" ,python-six)
       ("python-oauth2client" ,python-oauth2client)
       ("python-uritemplate" ,python-uritemplate)))
    (home-page "https://github.com/google/google-api-python-client")
    (synopsis "Core Python library for accessing Google APIs")
    (description "Python client library for Google's discovery based APIs")
    (license license:asl2.0)))

(define-public python2-google-api-client
  (package-with-python2 python-google-api-client))

(define-public python-hawkauthlib
  (package
    (name "python-hawkauthlib")
    (version "2.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "hawkauthlib" version))
       (sha256
        (base32
         "03ai47s4h8nfnrf25shbfvkm1b9n1ccd4nmmj280sg1fayi69zgg"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-requests" ,python-requests)
       ("python-webob" ,python-webob)))
    (home-page "https://github.com/mozilla-services/hawkauthlib")
    (synopsis "Hawk Access Authentication protocol")
    (description
     "This is a low-level Python library for implementing Hawk Access Authentication,
a simple HTTP request-signing scheme.")
    (license license:mpl2.0)))

(define-public python-pybrowserid
  (package
    (name "python-pybrowserid")
    (version "0.14.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "PyBrowserID" version))
       (sha256
        (base32
         "1qvi79kfb8x9kxkm5lw2mp42hm82cpps1xknmsb5ghkwx1lpc8kc"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-requests" ,python-requests)))
    (native-inputs
     `(("python-mock" ,python-mock)))
    (home-page "https://github.com/mozilla/PyBrowserID")
    (synopsis "Python library for the BrowserID protocol")
    (description
     "This is a Python client library for the BrowserID protocol that
underlies Mozilla Persona.")
    (license license:mpl2.0)))
