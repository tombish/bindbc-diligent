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

module bindbc.diligent.graphics.metal.shadermtl;

/// \file
/// Definition of the Diligent::IShaderMtl interface

import bindbc.diligent.graphics.shader;

// {07182C29-CC3B-43B2-99D8-A77F6FECBA82}
static const INTERFACE_ID IID_ShaderMtl =
    {0x7182c29, 0xcc3b, 0x43b2, {0x99, 0xd8, 0xa7, 0x7f, 0x6f, 0xec, 0xba, 0x82}};

/// Exposes Metal-specific functionality of a shader object.
struct IShaderMtlMethods
{
    /// Returns the point to Metal shader function (MTLFunction)
    MTLFunction** GetMtlShaderFunction(IShaderMtl*);
}

struct IShaderMtlVtbl { IShaderMtlMethods ShaderMtl; }
struct IShaderMtl { IShaderMtlVtbl* pVtbl; }

MTLFunction** IShaderMtl_GetMtlShaderFunction(IShaderMtl* shader) {
    return shader.pVtbl.ShaderMtl.GetMtlShaderFunction(shader);
}