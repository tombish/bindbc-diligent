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

module bindbc.diligent.graphics.metal.pipelinestatemtl;

/// \file
/// Definition of the Diligent::IPipeplineStateMtl interface

import bindbc.diligent.graphics.pipelinestate;

// {B6A17C51-CCA9-44E1-A2DC-5DE250CF85AD}
static const INTERFACE_ID IID_PipelineStateMtl =
    INTERFACE_ID(0xb6a17c51, 0xcca9, 0x44e1, [0xa2, 0xdc, 0x5d, 0xe2, 0x50, 0xcf, 0x85, 0xad]);

/// Exposes Metal-specific functionality of a pipeline state object.
struct IPipelineStateMtlMethods
{
    /// Returns a pointer to Metal render pipeline (MTLRenderPipelineState)
    MTLRenderPipelineState** GetMtlRenderPipeline(IPipelineStateMtl*);

    /// Returns a pointer to Metal compute pipeline (MTLComputePipelineState)
    MTLComputePipelineState** GetMtlComputePipeline(IPipelineStateMtl*);

    /// Returns a pointer to Metal depth-stencil state object (MTLDepthStencilState)
    MTLDepthStencilState** GetMtlDepthStencilState(IPipelineStateMtl*);
}

struct IPipelineStateMtlVtbl { IPipelineStateMtlMethods PipelineStateMtl; }
struct IPipelineStateMtl { IPipelineStateMtlVtbl* pVtbl; }

MTLRenderPipelineState** IPipelineStateMtl_GetMtlRenderPipeline(IPipelineStateMtl* pipelineState) {
    return pipelineState.pVtbl.PipelineStateMtl.GetMtlRenderPipeline(pipelineState);
}

MTLComputePipelineState** IPipelineStateMtl_GetMtlComputePipeline(IPipelineStateMtl* pipelineState) {
    return pipelineState.pVtbl.PipelineStateMtl.GetMtlComputePipeline(pipelineState);
}

MTLDepthStencilState** IPipelineStateMtl_GetMtlDepthStencilState(IPipelineStateMtl* pipelineState) {
    return pipelineState.pVtbl.PipelineStateMtl.GetMtlDepthStencilState(pipelineState);
}
