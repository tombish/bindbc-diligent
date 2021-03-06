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

module bindbc.diligent.graphics.metal.bufferviewmtl;

/// \file
/// Definition of the Diligent::IBufferViewMtl interface

import bindbc.diligent.graphics.bufferview;

// {6D8B8199-1011-42B6-80DF-A9FA8B4F33FF}
static const INTERFACE_ID IID_BufferViewMtl =
    INTERFACE_ID(0x6d8b8199, 0x1011, 0x42b6, [0x80, 0xdf, 0xa9, 0xfa, 0x8b, 0x4f, 0x33, 0xff]);

/// Exposes Metal-specific functionality of a buffer view object.
struct IBufferViewMtlMethods
{
    MTLTexture** GetMtlTextureView(IBufferViewMtl*);
}

struct IBufferViewMtlVtbl { IBufferViewMtlMethods BufferViewMtl; }
struct IBufferViewMtl { IBufferViewMtlVtbl* pVtbl; }

MTLTexture** IBufferViewMtl_GetMtlTextureView(IBufferViewMtl* bufferView) {
    return bufferView.pVtbl.BufferViewMtl.GetMtlTextureView(bufferView);
}