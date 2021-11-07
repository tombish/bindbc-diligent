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

module bindbc.diligent.graphics.metal.buffermtl;

/// \file
/// Definition of the Diligent::IBufferMtl interface

import bindbc.diligent.graphics.buffer;

// {F8A1A3AC-923A-419D-AB9D-FE9E35DC654B}
static const INTERFACE_ID IID_BufferMtl =
    INTERFACE_ID(0xf8a1a3ac, 0x923a, 0x419d, [0xab, 0x9d, 0xfe, 0x9e, 0x35, 0xdc, 0x65, 0x4b]);

/// Exposes Metal-specific functionality of a buffer object.
struct IBufferMtlMethods
{
    /// Returns a pointer to a Metal buffer object.
    MTLBuffer** GetMtlResource(IBufferMtl*);
}

struct IBufferMtlVtbl { IBufferMtlMethods BufferMtl; }
struct IBufferMtl { IBufferMtlVtbl* pVtbl; }

MTLBuffer** IBufferMtl_GetMtlResource(IBufferMtl* buffer) {
    return buffer.pVtbl.BufferMtl.GetMtlResource(buffer);
}
