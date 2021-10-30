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

module bindbc.diligent.graphics.d3d12.pipelinestated3d12;

/// \file
/// Definition of the Diligent::IPipeplineStateD3D12 interface

#include "../../GraphicsEngine/interface/PipelineState.h"

// {33C9BE4B-6F23-4F83-A665-5AC1836DF35A}
static const INTERFACE_ID IID_PipelineStateD3D12 =
    {0x33c9be4b, 0x6f23, 0x4f83, {0xa6, 0x65, 0x5a, 0xc1, 0x83, 0x6d, 0xf3, 0x5a}};

#define DILIGENT_INTERFACE_NAME IPipelineStateD3D12
#include "../../../Primitives/interface/DefineInterfaceHelperMacros.h"

#define IPipelineStateD3D12InclusiveMethods \
    IPipelineStateInclusiveMethods;         \
    IPipelineStateD3D12Methods PipelineStateD3D12

/// Exposes Direct3D12-specific functionality of a pipeline state object.
DILIGENT_BEGIN_INTERFACE(IPipelineStateD3D12, IPipelineState)
{
    /// Returns ID3D12PipelineState interface of the internal D3D12 pipeline state object object.

    /// The method does *NOT* increment the reference counter of the returned object,
    /// so Release() must not be called.
    VIRTUAL ID3D12PipelineState*GetD3D12PipelineState(THIS) CONST PURE;

    /// Returns ID3D12StateObject interface of the internal D3D12 state object for ray tracing.

    /// The method does *NOT* increment the reference counter of the returned object,
    /// so Release() must not be called.
    VIRTUAL ID3D12StateObject*GetD3D12StateObject(THIS) CONST PURE;

    /// Returns a pointer to the root signature object associated with this pipeline state.

    /// The method does *NOT* increment the reference counter of the returned object,
    /// so Release() must not be called.
    VIRTUAL ID3D12RootSignature*GetD3D12RootSignature(THIS) CONST PURE;
};
DILIGENT_END_INTERFACE

#include "../../../Primitives/interface/UndefInterfaceHelperMacros.h"

#if DILIGENT_C_INTERFACE

#    define IPipelineStateD3D12_GetD3D12PipelineState(This) CALL_IFACE_METHOD(PipelineStateD3D12, GetD3D12PipelineState, This)
#    define IPipelineStateD3D12_GetD3D12StateObject(This)   CALL_IFACE_METHOD(PipelineStateD3D12, GetD3D12StateObject,   This)
#    define IPipelineStateD3D12_GetD3D12RootSignature(This) CALL_IFACE_METHOD(PipelineStateD3D12, GetD3D12RootSignature, This)

#endif


