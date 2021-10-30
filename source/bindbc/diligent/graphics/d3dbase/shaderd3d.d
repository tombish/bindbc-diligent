/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 */
 
/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *  Copyright 2015-2019 Egor Yusov
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
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

module bindbc.diligent.graphics.d3dbase.shaderd3d;

/// \file
/// Definition of the Diligent::IShaderD3D interface and related data structures

import bindbc.diligent.graphics.shader;

// {1EA0898C-1612-457F-B74E-808843D2CBE3}
static const INTERFACE_ID IID_ShaderD3D =
    INTERFACE_ID(0x1ea0898c, 0x1612, 0x457f, [0xb7, 0x4e, 0x80, 0x88, 0x43, 0xd2, 0xcb, 0xe3]);

/// HLSL resource description
struct HLSLShaderResourceDesc
{
    ShaderResourceDesc _ShaderResourceDesc;

    uint ShaderRegister = 0;
}

/// Exposes Direct3D-specific functionality of a shader object.
struct IShaderD3DMethods
{
    /// Returns HLSL shader resource description
    void* GetHLSLResource(IShaderD3D*, uint Index, HLSLShaderResourceDesc* ResourceDesc);
}

struct IShaderD3DVtbl { IShaderD3DMethods ShaderD3D; }
struct IShaderD3D { IShaderD3DVtbl* pVtbl; }

void* IShaderD3D_GetHLSLResource(IShaderD3D* shader, uint index, HLSLShaderResourceDesc* resourceDesc) {
    return shader.pVtbl.ShaderD3D.GetHLSLResource(shader, index, resourceDesc);
}