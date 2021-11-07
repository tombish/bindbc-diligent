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

module bindbc.diligent.graphics.metal.renderdevicemtl;

/// \file
/// Definition of the Diligent::IRenderDeviceMtl interface

import bindbc.diligent.graphics.renderdevice;

// {8D483E4A-2D53-47B2-B8D7-276F4CE57F68}
static const INTERFACE_ID IID_RenderDeviceMtl =
    INTERFACE_ID(0x8d483e4a, 0x2d53, 0x47b2, [0xb8, 0xd7, 0x27, 0x6f, 0x4c, 0xe5, 0x7f, 0x68]);

/// Exposes Metal-specific functionality of a render device.
struct IRenderDeviceMtlMethods
{
    /// Returns the pointer to Metal device (MTLDevice).
    MTLDevice** GetMtlDevice(IRenderDeviceMtl*);

    /// Creates a texture from existing Metal resource
    void* CreateTextureFromMtlResource(IRenderDeviceMtl*,
                                                      MTLTexture*    mtlTexture,
                                                      RESOURCE_STATE InitialState,
                                                      ITexture**     ppTexture);

    /// Creates a buffer from existing Metal resource
    void* CreateBufferFromMtlResource(IRenderDeviceMtl*,
                                                     MTLBuffer*         mtlBuffer,
                                                     const(BufferDesc)* BuffDesc,
                                                     RESOURCE_STATE     InitialState,
                                                     IBuffer**          ppBuffer);

    /// Creates a buffer from existing Metal resource
    void* CreateBLASFromMtlResource(IRenderDeviceMtl*,
                                                   MTLAccelerationStructure*  mtlBLAS,
                                                   const(BottomLevelASDesc)*  Desc,
                                                   RESOURCE_STATE             InitialState,
                                                   IBottomLevelAS**           ppBLAS);

    /// Creates a buffer from existing Metal resource
    void* CreateTLASFromMtlResource(IRenderDeviceMtl*,
                                                   MTLAccelerationStructure* mtlTLAS,
                                                   const(TopLevelASDesc)*    Desc,
                                                   RESOURCE_STATE            InitialState,
                                                   ITopLevelAS**             ppTLAS);
}

struct IRenderDeviceMtlVtbl { IRenderDeviceMtlMethods RenderDeviceMtl; }
struct IRenderDeviceMtl { IRenderDeviceMtlVtbl* pVtbl; }

MTLDevice** IRenderDeviceMtl_GetMtlDevice(IRenderDeviceMtl* device) {
    return device.pVtbl.RenderDeviceMtl.GetMtlDevice(device);
}

// void* IRenderDeviceMtl_GetMtlCommandQueue(IRenderDeviceMtl* device) {}

void* IRenderDeviceMtl_CreateTextureFromMtlResource(IRenderDeviceMtl* device,
                                                      MTLTexture*    mtlTexture,
                                                      RESOURCE_STATE initialState,
                                                      ITexture**     ppTexture) {
    return device.pVtbl.RenderDeviceMtl.CreateTextureFromMtlResource(device, mtlTexture, initialState, ppTexture);
}

void* IRenderDeviceMtl_CreateBufferFromMtlResource(IRenderDeviceMtl* device,
                                                     MTLBuffer*         mtlBuffer,
                                                     const(BufferDesc)* buffDesc,
                                                     RESOURCE_STATE     initialState,
                                                     IBuffer**          ppBuffer) {
    return device.pVtbl.RenderDeviceMtl.CreateBufferFromMtlResource(device, mtlBuffer, buffDesc, initialState, ppBuffer);
}

void* IRenderDeviceMtl_CreateBLASFromMtlResource(IRenderDeviceMtl* device,
                                                   MTLAccelerationStructure*  mtlBLAS,
                                                   const(BottomLevelASDesc)*  desc,
                                                   RESOURCE_STATE             initialState,
                                                   IBottomLevelAS**           ppBLAS) {
    return device.pVtbl.RenderDeviceMtl.CreateBLASFromMtlResource(device, mtlBLAS, desc, initialState, ppBLAS);
}

void* IRenderDeviceMtl_CreateTLASFromMtlResource(IRenderDeviceMtl* device,
                                                   MTLAccelerationStructure* mtlTLAS,
                                                   const(TopLevelASDesc)*    desc,
                                                   RESOURCE_STATE            initialState,
                                                   ITopLevelAS**             ppTLAS) {
    return device.pVtbl.RenderDeviceMtl.CreateTLASFromMtlResource(device, mtlTLAS, desc, initialState, ppTLAS);
}
