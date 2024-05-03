<%
import re
from templates import helper as th
%><%
    n=namespace
    N=n.upper()

    x=tags['$x']
    X=x.upper()
%>/*
 *
 * Copyright (C) 2019-2021 Intel Corporation
 *
 * SPDX-License-Identifier: MIT
 *
 * @file ${n}_ddi.h
 * @version v${ver}-r${rev}
 *
 */
#ifndef _${N}_DDI_VER_H
#define _${N}_DDI_VER_H
#if defined(__cplusplus)
#pragma once
#endif
#include "${n}_ddi.h"

#if defined(__cplusplus)
extern "C" {
#endif

%for tbl in th.get_pfntables(specs, meta, n, tags):
<%
  versions = list(set(float(obj['version']) if 'version' in obj else 1.0 for obj in tbl['functions']))
  versions.sort()
%>///////////////////////////////////////////////////////////////////////////////
/// ${versions}
/// @brief Table of ${tbl['name']} functions pointers
%for version in versions:
typedef struct _${tbl['type']}_${str(version).replace(".","_")}
{
    %for obj in tbl['functions']:
    %if version >= float(obj['version']) if 'version' in obj else 1.0:
    %if 'condition' in obj:
#if ${th.subt(n, tags, obj['condition'])}
    %endif
    ${th.append_ws(th.make_pfn_type(n, tags, obj), 59)} ${th.make_pfn_name(n, tags, obj)};
    %if 'condition' in obj:
#else
    ${th.append_ws("void*", 59)} ${th.make_pfn_name(n, tags, obj)};
#endif // ${th.subt(n, tags, obj['condition'])}
    %endif
    %endif
    %endfor
} ${tbl['type']}_${str(version).replace(".","_")};

%endfor
%endfor

#if defined(__cplusplus)
} // extern "C"
#endif

#endif // _${N}_DDI_VER_H
