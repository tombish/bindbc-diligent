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

module bindbc.diligent.graphics.metal.toplevelasmtl;

/// \file
/// Definition of the Diligent::ITopLevelASMtl interface

import bindbc.diligent.graphics.toplevelas;

// {2156C051-350D-4FCE-84F3-295B536622D3}
static const INTERFACE_ID IID_TopLevelASMtl =
    INTERFACE_ID(0x2156c051, 0x350d, 0x4fce, [0x84, 0xf3, 0x29, 0x5b, 0x53, 0x66, 0x22, 0xd3]);

/// Exposes Metal-specific functionality of a top-level acceleration structure object.
struct ITopLevelASMtlMethods
{
    /// Returns a pointer to a Metal acceleration structure object.
    MTLAccelerationStructure** GetMtlAccelerationStructure(ITopLevelASMtl*);
}

struct ITopLevelASMtlVtbl { ITopLevelASMtlMethods TopLevelASMtl; }
struct ITopLevelASMtl { ITopLevelASMtlVtbl* pVtbl; }

MTLAccelerationStructure** ITopLevelASMtl_GetMtlAccelerationStructure(ITopLevelASMtl* toplevelAS) {
    return toplevelAS.pVtbl.TopLevelASMtl.GetMtlAccelerationStructure(topLevelAS);
}
