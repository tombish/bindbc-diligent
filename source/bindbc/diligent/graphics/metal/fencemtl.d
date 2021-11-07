/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 */
 
/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF ANY PROPRIETARY RIGHTS.
 *
 *  In no event and under no legal theory, whether in tort (including negligence), 
 *  contract, or otherwise, unless required by applicable law (such as deliberate 
 *  and grossly negligent acts) or agreed to in writing, shall any Contributor be
 *  liable for any damages, including any direct, indirect, special, incidental, 
 *  or consequential damages of any character arising as a result of this License or 
 *  out of the use or inability to use the software (including but not limited to damages 
 *  for loss of goodwill, work stoppage, computer failure or malfunction, or any and 
 *  all other commercial damages or losses), even if such Contributor has been advised 
 *  of the possibility of such damages.
 */

module bindbc.diligent.graphics.metal.fencemtl;

/// \file
/// Definition of the Diligent::IFenceMtl interface

import bindbc.diligent.graphics.fence;

// {54FE9F8F-FBBF-4ABB-8280-D980982DA364}
static const INTERFACE_ID IID_FenceMtl =
    INTERFACE_ID(0x54fe9f8f, 0xfbbf, 0x4abb, [0x82, 0x80, 0xd9, 0x80, 0x98, 0x2d, 0xa3, 0x64]);

/// Exposes Metal-specific functionality of a fence object.
struct IFenceMtlMethods
{
    /// Returns a pointer to Metal shared event (MTLSharedEvent)
    MTLSharedEvent** GetMtlSharedEvent(IFenceMtl*);
}

struct IFenceMtlVtbl { IFenceMtlMethods FenceMtl; }
struct IFenceMtl { IFenceMtlVtbl* pVtbl; }

MTLSharedEvent** IFenceMtl_GetMtlSharedEvent(IFenceMtl* fence) {
    return fence.pVtbl.FenceMtl.GetMtlSharedEvent(fence);
}